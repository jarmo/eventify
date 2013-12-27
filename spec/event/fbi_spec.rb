require "spec_helper"

describe Event::FBI do
  context "#fetch" do
    it "fetches events" do
      stub_request(:get, Event::FBI::URL).to_return(body: File.read(File.expand_path("../support/fbi.html", __dir__)))

      events = Event::FBI.fetch
      events.should == [
        Event::FBI.new(
          title: "BONOBO Tallinna kontsert on välja müüdud",
          link: "http://www.fbi.ee/bonobo-tallinna-kontsert-on-valja-muudud/",
          date: Time.now,
          id: "http://www.fbi.ee/bonobo-tallinna-kontsert-on-valja-muudud/"
        ),
        Event::FBI.new(
          title: "Rokilegend ROBERT PLANT esineb oma bändiga Tallinnas",
          link: "http://www.fbi.ee/rokilegend-robert-plant-esineb-oma-bandiga-tallinnas/",
          date: Time.now,
          id: "http://www.fbi.ee/rokilegend-robert-plant-esineb-oma-bandiga-tallinnas/"
        )
      ]
    end
  end
end
