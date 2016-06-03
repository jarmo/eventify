require "spec_helper"

describe Eventify::Provider::Piletilevi do
  context "#fetch" do
    it "fetches events" do
      stub_request(:get, Eventify::Provider::Piletilevi::URL.to_s).to_return(body: File.read(File.expand_path("../../support/piletilevi.json", __dir__)))

      events = Eventify::Provider::Piletilevi.fetch
      events.should == [
        Eventify::Provider::Piletilevi.new(
          title:"Jelena Vaenga \/ \u0415\u043b\u0435\u043d\u0430 \u0412\u0430\u0435\u043d\u0433\u0430",
          link:"http:/\/www.piletilevi.ee\/est\/piletid\/muusika\/rock-ja-pop\/jelena-vaenga-elena-vaenga-190326\/",
          date: Time.at(1484326800),
          id: "190326"
        ),
        Eventify::Provider::Piletilevi.new(
          title:"Head t\u00fc\u00fcbid",
          link:"http:\/\/www.piletilevi.ee\/est\/piletid\/film\/krimifilm\/head-tuubid-190410\/",
          date: Time.at(1465405200),
          id: "190410"
        ),
        Eventify::Provider::Piletilevi.new(
          title:"Teismelised ninjakilpkonnad: Varjust v\u00e4lja (3D)",
          link:"http:\/\/www.piletilevi.ee\/est\/piletid\/film\/marul\/teismelised-ninjakilpkonnad-varjust-valja-3d-190405\/",
          date: Time.at(1465491600),
          id: "190405"
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
