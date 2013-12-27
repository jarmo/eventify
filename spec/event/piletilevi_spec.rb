require "spec_helper"
require "event/piletilevi"

describe Event::Piletilevi do
  context "#fetch" do
    it "fetches events" do
      stub_request(:get, Event::Piletilevi::MUSIC_URL).to_return(body: File.read(File.expand_path("../support/piletilevi-muusika.xml", __dir__)))

      events = Event::Piletilevi.fetch
      events.should == [
        Event::Piletilevi.new(
          title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
          link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
          date: Time.parse("2013-12-27 12:30:11"),
          id: "86362"
        ),
        Event::Piletilevi.new(
          title: "Ott Lepland 04.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
          link: "http://www.piletilevi.ee/est/piletid/muusika/show/?concert=138050",
          date: Time.parse("2013-12-27 11:16:14"),
          id: "86359"
        )
      ]
    end
  end
end
