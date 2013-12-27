require "spec_helper"
require "event/base"

describe Event::Base do
  context "#initialize" do
    it "parses event" do
      event = {
        id: "86362",
        provider: "foo",
        title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
        date: Time.parse("2013-12-27 12:30:11"),
      }

      parsed_event = Event::Base.new(event)
      parsed_event.guid.should == "foo-86362"
      parsed_event.provider.should == "foo"
      parsed_event.title.should == event[:title]
      parsed_event.link.should == event[:link]
      parsed_event.date.should == event[:date]
    end
  end
end
