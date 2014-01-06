require "spec_helper"

describe Eventify::Provider::Ticketpro do

  context "#initialize" do
    it "strips en localization info from id" do
      Eventify::Provider::Ticketpro.new(
        title: "Danny Malando tantsumuusika orkester ( Holland )",
        link: "http://www.ticketpro.ee/jnp/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html",
        date: Time.parse("Fri, 31 May 2013 14:29:07 +0200"),
        id: "http://www.ticketpro.ee/jnp/en/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html"
      ).id.should == "http://www.ticketpro.ee/jnp/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html"
    end

    it "strips ru localization info from id" do
      Eventify::Provider::Ticketpro.new(
        title: "Danny Malando tantsumuusika orkester ( Holland )",
        link: "http://www.ticketpro.ee/jnp/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html",
        date: Time.parse("Fri, 31 May 2013 14:29:07 +0200"),
        id: "http://www.ticketpro.ee/jnp/ru/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html"
      ).id.should == "http://www.ticketpro.ee/jnp/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html"
    end

    it "strips en localization info from link" do
      Eventify::Provider::Ticketpro.new(
        title: "Danny Malando tantsumuusika orkester ( Holland )",
        link: "http://www.ticketpro.ee/jnp/en/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html",
        date: Time.parse("Fri, 31 May 2013 14:29:07 +0200"),
        id: "http://www.ticketpro.ee/jnp/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html"
      ).link.should == "http://www.ticketpro.ee/jnp/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html"
    end

    it "strips ru localization info from link" do
      Eventify::Provider::Ticketpro.new(
        title: "Danny Malando tantsumuusika orkester ( Holland )",
        link: "http://www.ticketpro.ee/jnp/ru/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html",
        date: Time.parse("Fri, 31 May 2013 14:29:07 +0200"),
        id: "http://www.ticketpro.ee/jnp/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html"
      ).link.should == "http://www.ticketpro.ee/jnp/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html"
    end
  end

  context "#fetch" do
    it "fetches events" do
      stub_request(:get, Eventify::Provider::Ticketpro::URL).to_return(body: File.read(File.expand_path("../../support/ticketpro.xml", __dir__)))

      events = Eventify::Provider::Ticketpro.fetch
      events.should == [
        Eventify::Provider::Ticketpro.new(
          title: "KGB teater-kohvik-muuseum",
          link: "http://www.ticketpro.ee/jnp/theatre/1080200-kgb-teater-kohvik-muuseum.html",
          date: Time.parse("Mon, 06 May 2013 09:33:26 +0200"),
          id: "http://www.ticketpro.ee/jnp/theatre/1080200-kgb-teater-kohvik-muuseum.html"
        ),
        Eventify::Provider::Ticketpro.new(
          title: "Danny Malando tantsumuusika orkester ( Holland )",
          link: "http://www.ticketpro.ee/jnp/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html",
          date: Time.parse("Fri, 31 May 2013 14:29:07 +0200"),
          id: "http://www.ticketpro.ee/jnp/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html"
        )
      ]
    end
  end
end
