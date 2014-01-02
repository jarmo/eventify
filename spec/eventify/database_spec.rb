require "spec_helper"

describe Eventify::Database do
  context ".save" do
    it "saves events into database" do
      event1 = Eventify::Provider::Base.new(
        id: "86362",
        title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
        date: Time.parse("2013-12-27 12:30:11"),
      )
      Eventify::Database.save event1

      event2 = Eventify::Provider::Base.new(
        id: "86363",
        title: "Second event",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138080",
        date: Time.parse("2013-12-27 12:30:12"),
      )
      Eventify::Database.save event2

      Eventify::Database.events.size.should == 2
      Eventify::Database.events.should == [event1, event2]
    end

    it "raises an error when event already exists" do
      event = Eventify::Provider::Base.new(
        id: "86362",
        title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
        date: Time.parse("2013-12-27 12:30:11"),
      )
      Eventify::Database.save event

      expect {
        Eventify::Database.save event
      }.to raise_error
    end
  end

  context ".exists?" do
    it "true when event exists" do
      event = Eventify::Provider::Base.new(
        id: "86362",
        title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
        date: Time.parse("2013-12-27 12:30:11"),
      )
      Eventify::Database.save(event)

      Eventify::Database.should exist(event)
    end

    it "false when event does not exist" do
      event = Eventify::Provider::Base.new(
        id: "86362",
        title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
        date: Time.parse("2013-12-27 12:30:11"),
      )

      Eventify::Database.should_not exist(event)
    end

    it "false when event id is different" do
      event1 = Eventify::Provider::Base.new(
        id: "86362",
        title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
        date: Time.parse("2013-12-27 12:30:11"),
      )
      Eventify::Database.save(event1)

      event2 = Eventify::Provider::Base.new(
        id: "86363",
        title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
        date: Time.parse("2013-12-27 12:30:11"),
      )

      Eventify::Database.should_not exist(event2)
    end

    it "false when event link is different" do
      event1 = Eventify::Provider::Base.new(
        id: "86362",
        title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
        date: Time.parse("2013-12-27 12:30:11"),
      )
      Eventify::Database.save(event1)

      event2 = Eventify::Provider::Base.new(
        id: "86362",
        title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138099",
        date: Time.parse("2013-12-27 12:30:11"),
      )

      Eventify::Database.should_not exist(event2)
    end

    it "false when event provider is different" do
      event1 = Eventify::Provider::Base.new(
        id: "86362",
        title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
        date: Time.parse("2013-12-27 12:30:11"),
      )
      Eventify::Database.save(event1)

      event2 = Eventify::Provider::Piletilevi.new(
        id: "86362",
        title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
        link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
        date: Time.parse("2013-12-27 12:30:11"),
      )

      Eventify::Database.should_not exist(event2)
    end
  end

  it ".events loads events from database" do
    event1 = Eventify::Provider::Base.new(
      id: "86362",
      title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
      link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
      date: Time.parse("2013-12-27 12:30:11"),
    )
    Eventify::Database.save(event1)

    event2 = Eventify::Provider::Piletilevi.new(
      id: "86363",
      title: "Koit Toome ja Karl-Erik Taukar 17.01.2014 - 21:00 - Rock Cafe, Tallinn, Eesti",
      link: "http://www.piletilevi.ee/est/piletid/muusika/rock_ja_pop/?concert=138090",
      date: Time.parse("2013-12-27 12:30:22"),
    )
    Eventify::Database.save(event2)

    Eventify::Database.events.should == [event1, event2]
  end
end
