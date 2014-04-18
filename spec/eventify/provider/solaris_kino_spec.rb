require "spec_helper"

describe Eventify::Provider::SolarisKino do
  context "#fetch" do
    it "fetches events" do
      stub_request(:get, URI.join(Eventify::Provider::SolarisKino::URL, "et/tulemas/").to_s).to_return(body: File.read(File.expand_path("../../support/solaris_kino.html", __dir__)))

      events = Eventify::Provider::SolarisKino.fetch
      events.should == [
        Eventify::Provider::SolarisKino.new(
          title: "Tuul tõuseb/Kaze Tachinu (2014)",
          link: "http://solariskino.ee/et/kinokavad/tuul-touseb/",
          date: Time.now,
          id: "Tuul tõuseb/Kaze Tachinu (2014)"
        ),
        Eventify::Provider::SolarisKino.new(
          title: "Kiki kullerteenus/Majo no Takkyuubin (2014)",
          link: "http://solariskino.ee/et/kinokavad/kiki-kullerteenus/",
          date: Time.now,
          id: "Kiki kullerteenus/Majo no Takkyuubin (2014)" 
        ),
        Eventify::Provider::SolarisKino.new(
          title: "Kättemaks kõrgetel kontsadel/The Other Woman (2014)",
          link: "http://solariskino.ee/et/kinokavad/kattemaks-korgetel-kontsadel/",
          date: Time.now,
          id: "Kättemaks kõrgetel kontsadel/The Other Woman (2014)"
        )
      ]
    end
  end
end
