require "spec_helper"

describe EventProvider::Base do
  context ".fetch" do
    it "needs to be implemented" do
      class EventProvider::CustomEvent < EventProvider::Base; end

      expect {
        EventProvider::CustomEvent.fetch
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

      parsed_event = EventProvider::Base.new(event)
      parsed_event.id.should == "86362"
      parsed_event.provider.should == "EventProvider::Base"
      parsed_event.title.should == event[:title]
      parsed_event.link.should == event[:link]
      parsed_event.date.should == event[:date]
    end

    it "raises an error when id is missing" do
      event = {
        title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
        date: Time.parse("2013-12-27 12:30:11"),
      }

      expect {
        EventProvider::Base.new(event)
      }.to raise_error(EventProvider::Base::MissingAttributeError)
    end

    it "raises an error when title is missing" do
      event = {
        id: "86362",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
        date: Time.parse("2013-12-27 12:30:11"),
      }

      expect {
        EventProvider::Base.new(event)
      }.to raise_error(EventProvider::Base::MissingAttributeError)
    end

    it "raises an error when link is missing" do
      event = {
        id: "86362",
        title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
        date: Time.parse("2013-12-27 12:30:11"),
      }

      expect {
        EventProvider::Base.new(event)
      }.to raise_error(EventProvider::Base::MissingAttributeError)
    end
  end

  context "#provider" do
    it "uses class name" do
      class EventProvider::CustomEvent < EventProvider::Base; end
      EventProvider::CustomEvent.new(id: "123", title: "foo", link: "http://example.org").provider.should == "EventProvider::CustomEvent"
    end
  end

  context "#==" do
    it "true when id and provider match" do
      EventProvider::Base.new(id: "123", title: "foo", link: "http://example.org").should == EventProvider::Base.new(id: "123", title: "foo", link: "http://example.org")
    end

    it "false when id does not match" do
      EventProvider::Base.new(id: "123", title: "foo", link: "http://example.org").should_not == EventProvider::Base.new(id: "321", title: "foo", link: "http://example.org")
    end

    it "false when class does not match" do
      class EventProvider::CustomEvent < EventProvider::Base; end
      EventProvider::CustomEvent.new(id: "123", title: "foo", link: "http://example.org").should_not ==  EventProvider::Base.new(id: "123", title: "foo", link: "http://example.org")
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
      EventProvider::Base.new(event).save

      Db.events.size.should == 1
    end

    it "returns self" do
      event = {
        id: "86362",
        title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
        date: Time.parse("2013-12-27 12:30:11"),
      }
      event_instance = EventProvider::Base.new(event)
      event_instance.save.should == event_instance
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
      EventProvider::Base.new(event).save

      EventProvider::Base.new(event).should exist
    end

    it "false for not existing event" do
      event = {
        id: "86362",
        title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
        date: Time.parse("2013-12-27 12:30:11"),
      }

      EventProvider::Base.new(event).should_not exist
    end
  end

  it "sorts by title" do
    event1 = EventProvider::Base.new(id: "123", title: "foo", link: "http://example.org")
    event2 = EventProvider::Piletilevi.new(id: "123", title: "bar", link: "http://example.org")
    [event1, event2].sort.should == [event2, event1]
  end
end
