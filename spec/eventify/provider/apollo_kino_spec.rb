require "spec_helper"

describe Eventify::Provider::ApolloKino do
  context "#fetch" do
    it "fetches events" do
      stub_request(:get, URI.join(Eventify::Provider::ApolloKino::URL, "eng/soon").to_s).to_return(body: File.read(File.expand_path("../../support/apollo_kino.html", __dir__)))

      events = Eventify::Provider::ApolloKino.fetch
      expect(events).to eq([
        Eventify::Provider::ApolloKino.new(
          title: "Võimlemisklubi Janika TALVEKONTSERT",
          link: "https://www.apollokino.ee/eng/event/4127/title/v%C3%B5imlemisklubi_janika_talvekontsert/",
          date: Time.parse("2021-01-31"),
          id: "https://www.apollokino.ee/eng/event/4127/title/v%C3%B5imlemisklubi_janika_talvekontsert/"
        ),
        Eventify::Provider::ApolloKino.new(
          title: "Jurassic World: Dominion",
          link: "https://www.apollokino.ee/eng/event/4064/title/jurassic_world_dominion/",
          date: Time.parse("2022-06-10"),
          id: "https://www.apollokino.ee/eng/event/4064/title/jurassic_world_dominion/",
        ),
      ])
    end
  end
end
