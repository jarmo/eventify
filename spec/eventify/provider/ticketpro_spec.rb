require "spec_helper"

describe Eventify::Provider::Ticketpro do
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

  context "#==" do
    it "true between non-localized and ru localized event" do
      not_localized_event = Eventify::Provider::Ticketpro.new(
        title: "Danny Malando tantsumuusika orkester ( Holland )",
        link: "http://www.ticketpro.ee/jnp/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html",
        date: Time.parse("Fri, 31 May 2013 14:29:07 +0200"),
        id: "http://www.ticketpro.ee/jnp/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html"
      )

      ru_localized_event = Eventify::Provider::Ticketpro.new(
        title: "Danny Malando tantsumuusika orkester ( Holland )",
        link: "http://www.ticketpro.ee/jnp/ru/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html",
        date: Time.parse("Fri, 31 May 2013 14:29:07 +0200"),
        id: "http://www.ticketpro.ee/jnp/ru/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html"
      )

      not_localized_event.should == ru_localized_event
    end

    it "true between non-localized and en localized event" do
      not_localized_event = Eventify::Provider::Ticketpro.new(
        title: "Danny Malando tantsumuusika orkester ( Holland )",
        link: "http://www.ticketpro.ee/jnp/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html",
        date: Time.parse("Fri, 31 May 2013 14:29:07 +0200"),
        id: "http://www.ticketpro.ee/jnp/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html"
      )

      en_localized_event = Eventify::Provider::Ticketpro.new(
        title: "Danny Malando tantsumuusika orkester ( Holland )",
        link: "http://www.ticketpro.ee/jnp/en/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html",
        date: Time.parse("Fri, 31 May 2013 14:29:07 +0200"),
        id: "http://www.ticketpro.ee/jnp/en/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html"
      )

      not_localized_event.should == en_localized_event
    end

    it "true between ru localized and en localized event" do
      ru_localized_event = Eventify::Provider::Ticketpro.new(
        title: "Danny Malando tantsumuusika orkester ( Holland )",
        link: "http://www.ticketpro.ee/jnp/ru/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html",
        date: Time.parse("Fri, 31 May 2013 14:29:07 +0200"),
        id: "http://www.ticketpro.ee/jnp/ru/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html"
      )      

      en_localized_event = Eventify::Provider::Ticketpro.new(
        title: "Danny Malando tantsumuusika orkester ( Holland )",
        link: "http://www.ticketpro.ee/jnp/en/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html",
        date: Time.parse("Fri, 31 May 2013 14:29:07 +0200"),
        id: "http://www.ticketpro.ee/jnp/en/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html"
      )

      ru_localized_event.should == en_localized_event
    end
  end

  context "#id" do
    it "strips out localized part of url" do
      Eventify::Provider::Ticketpro.new(
        title: "Danny Malando tantsumuusika orkester ( Holland )",
        link: "http://www.ticketpro.ee/jnp/en/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html",
        date: Time.parse("Fri, 31 May 2013 14:29:07 +0200"),
        id: "http://www.ticketpro.ee/jnp/en/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html"
      ).id.should == "http://www.ticketpro.ee/jnp/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html"
    end
  end
end
