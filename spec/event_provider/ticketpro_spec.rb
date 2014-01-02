require "spec_helper"

describe EventProvider::Ticketpro do
  context "#fetch" do
    it "fetches events" do
      stub_request(:get, EventProvider::Ticketpro::URL).to_return(body: File.read(File.expand_path("../support/ticketpro.xml", __dir__)))

      events = EventProvider::Ticketpro.fetch
      events.should == [
        EventProvider::Ticketpro.new(
          title: "KGB teater-kohvik-muuseum",
          link: "http://www.ticketpro.ee/jnp/theatre/1080200-kgb-teater-kohvik-muuseum.html",
          date: Time.parse("Mon, 06 May 2013 09:33:26 +0200"),
          id: "http://www.ticketpro.ee/jnp/theatre/1080200-kgb-teater-kohvik-muuseum.html"
        ),
        EventProvider::Ticketpro.new(
          title: "Danny Malando tantsumuusika orkester ( Holland )",
          link: "http://www.ticketpro.ee/jnp/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html",
          date: Time.parse("Fri, 31 May 2013 14:29:07 +0200"),
          id: "http://www.ticketpro.ee/jnp/music/1095688-danny-malando-tantsumuusika-orkester-holland-.html"
        )
      ]
    end
  end
end