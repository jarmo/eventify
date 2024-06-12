require "spec_helper"

describe Eventify::Provider::ApolloKino do
  context "#fetch" do
    it "fetches events" do
      stub_request(:get, Eventify::Provider::ApolloKino::URL.to_s).to_return(body: File.read(File.expand_path("../../support/apollo_kino.html", __dir__)))

      events = Eventify::Provider::ApolloKino.fetch
      expect(events).to eq([
        Eventify::Provider::ApolloKino.new(
          title: "Ingeborg Bachmann - Journey Into the Desert",
          link: "https://www.apollokino.ee/eng/event/5325/ingeborg_bachmann_-_journey_into_the_desert?theatreAreaID=1004",
          date: Time.parse("2024-06-14"),
          id: "https://www.apollokino.ee/eng/event/5325/ingeborg_bachmann_-_journey_into_the_desert?theatreAreaID=1004"
        ),
        Eventify::Provider::ApolloKino.new(
          title: "Inside Out 2",
          link: "https://www.apollokino.ee/eng/event/5395/inside_out_2?theatreAreaID=1004",
          date: Time.parse("2024-07-15"),
          id: "https://www.apollokino.ee/eng/event/5395/inside_out_2?theatreAreaID=1004",
        ),
      ])
    end
  end
end
