require "spec_helper"

describe Eventify::Provider::SolarisKino do
  context "#fetch" do
    it "fetches events" do
      stub_request(:get, Eventify::Provider::SolarisKino::URL).to_return(body: File.read(File.expand_path("../../support/solaris_kino.html", __dir__)))
      stub_request(:get, "http://solariskino.ee/et/kinokavad/tuul-touseb/").to_return(body: File.read(File.expand_path("../../support/solaris_kino_kaze_tachinu.html", __dir__)))
      stub_request(:get, "http://solariskino.ee/et/kinokavad/kattemaks-korgetel-kontsadel/").to_return(body: File.read(File.expand_path("../../support/solaris_kino_the_other_woman.html", __dir__)))

      events = Eventify::Provider::SolarisKino.fetch
      events.should == [
        Eventify::Provider::SolarisKino.new(
          title: "Tuul tõuseb/Kaze Tachinu (2014)",
          link: "http://solariskino.ee/et/kinokavad/tuul-touseb/",
          date: Time.now,
          id: "http://solariskino.ee/et/kinokavad/tuul-touseb/"
        ),
        Eventify::Provider::SolarisKino.new(
          title: "Kättemaks kõrgetel kontsadel/The Other Woman (2014)",
          link: "http://solariskino.ee/et/kinokavad/kattemaks-korgetel-kontsadel/",
          date: Time.now,
          id: "http://solariskino.ee/et/kinokavad/kattemaks-korgetel-kontsadel/"
        )
      ]
    end
  end
end
