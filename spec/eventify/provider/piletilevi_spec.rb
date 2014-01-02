require "spec_helper"

describe Eventify::Provider::Piletilevi do
  context "#fetch" do
    it "fetches events" do
      stub_request(:get, Eventify::Provider::Piletilevi::URLS[0]).to_return(body: File.read(File.expand_path("../../support/piletilevi-music.xml", __dir__)))
      stub_request(:get, Eventify::Provider::Piletilevi::URLS[1]).to_return(body: File.read(File.expand_path("../../support/piletilevi-news.xml", __dir__)))

      Eventify::Provider::Piletilevi::URLS[2..-1].each do |url|
        stub_request(:get, url).to_return(body: File.read(File.expand_path("../../support/piletilevi-empty.xml", __dir__)))
      end

      events = Eventify::Provider::Piletilevi.fetch
      events.should == [
        Eventify::Provider::Piletilevi.new(
          title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
          link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
          date: Time.parse("2013-12-27 12:30:11"),
          id: "86362"
        ),
        Eventify::Provider::Piletilevi.new(
          title: "Ott Lepland 04.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
          link: "http://www.piletilevi.ee/est/piletid/muusika/show/?concert=138050",
          date: Time.parse("2013-12-27 11:16:14"),
          id: "86359"
        ),
        Eventify::Provider::Piletilevi.new(
          title: "Homme startiva Green Christmasi ajakava on paigas",
          link: "http://www.piletilevi.ee/est/uudised/homme-startiva-green-christmasi-ajakava-on-paigas",
          date: Time.parse("Fri, 27 Dec 13 00:00:00 +0200"),
          id: "61041"
        )        
      ]
    end
  end
end
