require "spec_helper"

describe Eventify::Provider::Piletilevi do
  context "#fetch" do
    it "fetches events" do
      stub_request(:get, "https://www.piletilevi.ee/api/v1/events?language=et&page=1&pageSize=36&sortBy=date&sortOrder=ASC").to_return(body: File.read(File.expand_path("../../support/piletilevi-page1.json", __dir__)))
      stub_request(:get, "https://www.piletilevi.ee/api/v1/events?language=et&page=2&pageSize=36&sortBy=date&sortOrder=ASC").to_return(body: File.read(File.expand_path("../../support/piletilevi-page2.json", __dir__)))

      events = Eventify::Provider::Piletilevi.fetch
      expect(events).to eq([
        Eventify::Provider::Piletilevi.new(
          title:"Eesti Kontserdi kinkepilet",
          link: "https://www.piletilevi.ee/piletid/4XLFLKGPOI/eesti-kontserdi-kinkepilet",
          date: Time.parse("2018-10-25T20:59:00Z"),
          id: "4XLFLKGPOI"
        ),
        Eventify::Provider::Piletilevi.new(
          title: "Vaba Lava Kinkepilet",
          link: "https://www.piletilevi.ee/piletid/JM77KMXFXY/vaba-lava-kinkepilet",
          date: Time.parse("2018-12-31T10:00:00Z"),
          id: "JM77KMXFXY"
        ),
        Eventify::Provider::Piletilevi.new(
          title: "Misiganes",
          link: "https://www.piletilevi.ee/piletid/5XLFLKGPOI/misiganes",
          date: Time.parse("2019-10-25T20:59:00Z"),
          id: "5XLFLKGPOI"
        )        
      ])
    end
  end
end
