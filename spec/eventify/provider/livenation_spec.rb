require "spec_helper"

describe Eventify::Provider::Livenation do
  context "#fetch" do
    it "fetches events" do
      stub_request(:get, Eventify::Provider::Livenation::URL).to_return(body: File.read(File.expand_path("../../support/livenation.html", __dir__)))

      events = Eventify::Provider::Livenation.fetch
      events.should == [
        Eventify::Provider::Livenation.new(
          title: "CLANNAD - In A Lifetime Farewell Tour",
          link: "https://www.livenation.ee/show/1310067/clannad-in-a-lifetime-farewell-tour/tallinn/2021-03-30/ee",
          date: Time.parse("2021-3-30"),
          id: "https://www.livenation.ee/show/1310067/clannad-in-a-lifetime-farewell-tour/tallinn/2021-03-30/ee"
        ),
        Eventify::Provider::Livenation.new(
          title: "JAMES BLUNT - Once Upon A Mind Tour",
          link: "https://www.livenation.ee/show/1310003/james-blunt-once-upon-a-mind-tour/tallinn/2021-06-03/ee",
          date: Time.parse("2021-6-03"),
          id: "https://www.livenation.ee/show/1310003/james-blunt-once-upon-a-mind-tour/tallinn/2021-06-03/ee"
        )
      ]
    end
  end
end
