require "spec_helper"

describe Eventify::Provider::Livenation do
  context "#fetch" do
    it "fetches events" do
      stub_request(:get, Eventify::Provider::Livenation::URL).to_return(body: File.read(File.expand_path("../../support/livenation.json", __dir__)))

      events = Eventify::Provider::Livenation.fetch
      expect(events).to eq([
        Eventify::Provider::Livenation.new(
          title: "Mogwai",
          link: "https://www.livenation.ee/event/mogwai-tallinn-tickets-edp1569723",
          date: Time.parse("2025-09-08T00:00:00Z"),
          id: "1569723"
        ),
        Eventify::Provider::Livenation.new(
          title: "Smash Into Pieces",
          link: "https://www.livenation.ee/event/smash-into-pieces-tallinn-tickets-edp1602333",
          date: Time.parse("2025-10-06T00:00:00Z"),
          id: "1602333"
        )
      ])
    end
  end
end
