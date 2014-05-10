require "spec_helper"

describe Eventify::Provider::Piletilevi do
  context "#fetch" do
    it "fetches events" do
      stub_request(:get, Eventify::Provider::Piletilevi::URL.to_s).to_return(body: File.read(File.expand_path("../../support/piletilevi.json", __dir__)))

      events = Eventify::Provider::Piletilevi.fetch
      events.should == [
        Eventify::Provider::Piletilevi.new(
          title: "Deemonid",
          link: "http://www.piletilevi.ee/est/piletid/teater/muu/deemonid-146082/",
          date: Time.at(1399661703),
          id: "146082"
        ),
        Eventify::Provider::Piletilevi.new(
          title: "Naeru Akadeemia",
          link: "http://www.piletilevi.ee/est/piletid/teater/muu/naeru-akadeemia-146075/",
          date: Time.at(1399659968),
          id: "146075"
        ),
        Eventify::Provider::Piletilevi.new(
          title: "Utoopia rannik. III osa. Kaldale heidetud.",
          link: "http://www.piletilevi.ee/est/piletid/teater/muu/utoopia-rannik-iii-osa-kaldale-heidetud-146055/",
          date: Time.at(1399657875),
          id: "146055"
        )        
      ]
    end

    it "works without concerts" do
      stub_request(:get, Eventify::Provider::Piletilevi::URL.to_s).to_return(body: %q|{"responseData": {}}|)
      Eventify::Provider::Piletilevi.fetch.should == []
    end

    it "works without response data" do
      stub_request(:get, Eventify::Provider::Piletilevi::URL.to_s).to_return(body: %q|{"foo": {}}|)
      Eventify::Provider::Piletilevi.fetch.should == []
    end

    it "works without json response" do
      stub_request(:get, Eventify::Provider::Piletilevi::URL.to_s).to_return(body: %q|foo|)
      Eventify::Provider::Piletilevi.fetch.should == []
    end
  end
end
