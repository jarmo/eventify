require "spec_helper"
require "db"

describe Db do
  context ".save" do
    it "saves events into database" do
      event1 = {
        guid: "86362",
        provider: "foo",
        title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
        date: Time.parse("2013-12-27 12:30:11"),
      }
      Db.save event1

      event2 = {
        guid: "86363",
        provider: "foobar",
        title: "Second event",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138080",
        date: Time.parse("2013-12-27 12:30:12"),
      }
      Db.save event2

      Db.events.size.should == 2
      Db.events.should == [event1, event2]
    end

    it "returns true when event was new" do
      event = {
        guid: "86362",
        provider: "foo",
        title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
        date: Time.parse("2013-12-27 12:30:11"),
      }
      Db.save(event).should be_true
    end

    it "returns false when event was already stored" do
      event = {
        guid: "86362",
        provider: "foo",
        title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
        date: Time.parse("2013-12-27 12:30:11"),
      }
      Db.save(event)
      Db.save(event).should be_false
    end
  end
end
