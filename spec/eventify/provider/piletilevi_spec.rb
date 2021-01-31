require "spec_helper"

describe Eventify::Provider::Piletilevi do
  context "#fetch" do
    it "fetches events" do
      stub_request(:get, "#{Eventify::Provider::Piletilevi::URL}/page:1").to_return(body: File.read(File.expand_path("../../support/piletilevi-page1.json", __dir__)))
      stub_request(:get, "#{Eventify::Provider::Piletilevi::URL}/page:2").to_return(body: File.read(File.expand_path("../../support/piletilevi-page2.json", __dir__)))

      events = Eventify::Provider::Piletilevi.fetch
      expect(events).to eq([
        Eventify::Provider::Piletilevi.new(
          title:"Apsilankyk edukaciniame zoologijos sode ZOOPARK.LT",
          link: "https://www.piletilevi.ee/est/piletid/varia/apsilankyk-edukaciniame-zoologijos-sode-zooparklt-53017/",
          date: Time.at(1535871600),
          id: 53017
        ),
        Eventify::Provider::Piletilevi.new(
          title: "Huumoriteater ''ENSV kohvik''",
          link: "https://www.kinkekaart.ee/est/piletid/teater/komoodia/huumoriteater-ensv-kohvik-318916/",
          date: Time.at(1577898000),
          id: 21428
        ),
        Eventify::Provider::Piletilevi.new(
          title: "Viiuldaja katusel / J. Steini / J.Bocki / S. Harnicki muusikal",
          link: "https://www.piletilevi.ee/est/piletid/muusika/muusikal/viiuldaja-katusel-j-steini-jbocki-s-harnicki-muusikal-40385/",
          date: Time.at(1610038800),
          id: 40385
        )        
      ])
    end
  end
end
