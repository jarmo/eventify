require "spec_helper"

describe Event::Base do
  context "#initialize" do
    it "parses raw event" do
      event = {
        id: "86362",
        title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
        date: Time.parse("2013-12-27 12:30:11"),
      }

      parsed_event = Event::Base.new(event)
      parsed_event.id.should == "86362"
      parsed_event.provider.should == "Event::Base"
      parsed_event.title.should == event[:title]
      parsed_event.link.should == event[:link]
      parsed_event.date.should == event[:date]
    end
  end

  context "#provider" do
    it "uses class name" do
      class Event::CustomEvent < Event::Base; end
      Event::CustomEvent.new(id: "123").provider.should == "Event::CustomEvent"
    end
  end

  context "#==" do
    it "true when id and provider match" do
      Event::Base.new(id: "123").should == Event::Base.new(id: "123")
    end

    it "false when id does not match" do
      Event::Base.new(id: "123").should_not == Event::Base.new(id: "321")
    end

    it "false when class does not match" do
      class Event::CustomEvent < Event::Base; end
      Event::CustomEvent.new(id: "123").should_not ==  Event::Base.new(id: "123")
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
      Event::Base.new(event).save

      Db.events.size.should == 1
    end

    it "returns self" do
      event = {
        id: "86362",
        title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
        date: Time.parse("2013-12-27 12:30:11"),
      }
      event_instance = Event::Base.new(event)
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
      Event::Base.new(event).save

      Event::Base.new(event).should exist
    end

    it "false for not existing event" do
      event = {
        id: "86362",
        title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
        date: Time.parse("2013-12-27 12:30:11"),
      }

      Event::Base.new(event).should_not exist
    end
  end
end
