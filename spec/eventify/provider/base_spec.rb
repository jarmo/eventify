require "spec_helper"

describe Eventify::Provider::Base do
  context ".fetch" do
    it "needs to be implemented" do
      class Eventify::Provider::CustomEvent < Eventify::Provider::Base; end

      expect {
        Eventify::Provider::CustomEvent.fetch
      }.to raise_error(NotImplementedError)
    end
  end

  context "#initialize" do
    it "parses raw event" do
      event = {
        id: "86362",
        title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
        date: Time.parse("2013-12-27 12:30:11"),
      }

      parsed_event = Eventify::Provider::Base.new(event)
      expect(parsed_event.id).to eq("86362")
      expect(parsed_event.provider).to eq("Eventify::Provider::Base")
      expect(parsed_event.title).to eq(event[:title])
      expect(parsed_event.link).to eq(event[:link])
      expect(parsed_event.date).to eq(event[:date])
    end

    it "raises an error when id is missing" do
      event = {
        title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
        date: Time.parse("2013-12-27 12:30:11"),
      }

      expect {
        Eventify::Provider::Base.new(event)
      }.to raise_error(Eventify::Provider::Base::MissingAttributeError)
    end

    it "raises an error when title is missing" do
      event = {
        id: "86362",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
        date: Time.parse("2013-12-27 12:30:11"),
      }

      expect {
        Eventify::Provider::Base.new(event)
      }.to raise_error(Eventify::Provider::Base::MissingAttributeError)
    end

    it "raises an error when link is missing" do
      event = {
        id: "86362",
        title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
        date: Time.parse("2013-12-27 12:30:11"),
      }

      expect {
        Eventify::Provider::Base.new(event)
      }.to raise_error(Eventify::Provider::Base::MissingAttributeError)
    end
  end

  context "#provider" do
    it "uses class name" do
      class Eventify::Provider::CustomEvent < Eventify::Provider::Base; end
      expect(Eventify::Provider::CustomEvent.new(id: "123", title: "foo", link: "http://example.org").provider).to eq("Eventify::Provider::CustomEvent")
    end
  end

  context "#==" do
    it "true when id and provider match" do
      expect(Eventify::Provider::Base.new(id: "123", title: "foo", link: "http://example.org")).to eq(Eventify::Provider::Base.new(id: "123", title: "foo", link: "http://example.org"))
    end

    it "false when id does not match" do
      expect(Eventify::Provider::Base.new(id: "123", title: "foo", link: "http://example.org")).not_to eq(Eventify::Provider::Base.new(id: "321", title: "foo", link: "http://example.org"))
    end

    it "false when class does not match" do
      class Eventify::Provider::CustomEvent < Eventify::Provider::Base; end
      expect(Eventify::Provider::CustomEvent.new(id: "123", title: "foo", link: "http://example.org")).not_to eq(Eventify::Provider::Base.new(id: "123", title: "foo", link: "http://example.org"))
    end
  end

  context "#save" do
    it "saves event into database" do
      event = {
        id: "86362",
        title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
        date: Time.parse("2013-12-27 12:30:11"),
      }
      Eventify::Provider::Base.new(event).save

      expect(Eventify::Database.events.size).to eq(1)
    end

    it "returns self" do
      event = {
        id: "86362",
        title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
        date: Time.parse("2013-12-27 12:30:11"),
      }
      event_instance = Eventify::Provider::Base.new(event)
      expect(event_instance.save).to eq(event_instance)
    end
  end

  context "#exists?" do
    it "true for existing event" do
      event = {
        id: "86362",
        title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
        date: Time.parse("2013-12-27 12:30:11"),
      }
      Eventify::Provider::Base.new(event).save

      expect(Eventify::Provider::Base.new(event)).to exist
    end

    it "false for not existing event" do
      event = {
        id: "86362",
        title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
        date: Time.parse("2013-12-27 12:30:11"),
      }

      expect(Eventify::Provider::Base.new(event)).not_to exist
    end
  end

  it "sorts by title" do
    event1 = Eventify::Provider::Base.new(id: "123", title: "foo", link: "http://example.org")
    event2 = Eventify::Provider::Piletilevi.new(id: "123", title: "bar", link: "http://example.org")
    expect([event1, event2].sort).to eq([event2, event1])
  end
end
