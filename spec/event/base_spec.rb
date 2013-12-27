require "spec_helper"
require "event/base"

describe Event::Base do
  context "#initialize" do
    it "parses event" do
      event = {
        id: "86362",
        title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
        date: Time.parse("2013-12-27 12:30:11"),
      }

      parsed_event = Event::Base.new(event)
      parsed_event.guid.should == "base-86362"
      parsed_event.provider.should == "base"
      parsed_event.title.should == event[:title]
      parsed_event.link.should == event[:link]
      parsed_event.date.should == event[:date]
    end
  end

  context "#guid" do
    it "consists of provider and id" do
      class Event::CustomEvent < Event::Base; end
      Event::CustomEvent.new(id: "123").guid.should == "customevent-123"
    end
  end

  context "provider" do
    it "uses class name" do
      class Event::CustomEvent < Event::Base; end
      Event::CustomEvent.new(id: "123").provider.should == "customevent"
    end
  end
end
