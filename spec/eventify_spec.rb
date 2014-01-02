require "spec_helper"

describe Eventify do
  context "#new_events" do
    it "all are new" do
      eventify = Eventify.new
      events = [
        EventProvider::Base.new(id: "123", title: "foo", link: "http://example.org"),
        EventProvider::Base.new(id: "456", title: "bar", link: "http://example.org")
      ]
      eventify.stub(all_events: events)
      eventify.new_events.should == events
    end

    it "old ones are filtered out" do
      eventify = Eventify.new
      old_event = EventProvider::Base.new(id: "123", title: "foo", link: "http://example.org").save
      new_event = EventProvider::Base.new(id: "456", title: "bar", link: "http://example.org")
      events = [old_event, new_event]
      eventify.stub(all_events: events)

      eventify.new_events.should == [new_event]
    end

    it "caches the results" do
      eventify = Eventify.new

      event = EventProvider::Base.new(id: "123", title: "foo", link: "http://example.org")
      eventify.should_receive(:all_events).and_return([event])

      2.times { eventify.new_events.should == [event] }
    end
  end

  context "#all_events" do
    it "fetches all events from all providers" do
      eventify = Eventify.new
      eventify.providers.each do |provider|
        provider.should_receive :fetch
      end

      eventify.all_events
    end

    it "combines all events from all providers" do
      event1 = EventProvider::Piletilevi.new(id: "123", title: "foo", link: "http://example.org")
      event2 = EventProvider::Piletilevi.new(id: "456", title: "bar", link: "http://example.org")
      EventProvider::Piletilevi.stub(fetch: [event1, event2])

      event3 = EventProvider::Base.new(id: "123", title: "foo", link: "http://example.org")
      EventProvider::Base.stub(fetch: [event3])

      eventify = Eventify.new
      eventify.stub(providers: [EventProvider::Piletilevi, EventProvider::Base])
      eventify.all_events.should == [event1, event2, event3]
    end

    it "caches results" do
      eventify = Eventify.new
      eventify.should_receive(:providers).once.and_return([EventProvider::Base])
      EventProvider::Base.should_receive(:fetch).once.and_return([1])

      eventify.all_events.should == [1]
      eventify.all_events.should == [1]
    end

    it "removes duplicate entries" do
      event1 = EventProvider::Piletilevi.new(id: "123", title: "foo", link: "http://example.org")
      event2 = EventProvider::Piletilevi.new(id: "123", title: "foo", link: "http://example.org")
      event1.should == event2
      EventProvider::Piletilevi.stub(fetch: [event1, event2])

      eventify = Eventify.new
      eventify.stub(providers: [EventProvider::Piletilevi])
      eventify.all_events.should == [event1]
    end
  end

  context "#providers" do
    it "returns all providers" do
      Eventify.new.providers.should == [EventProvider::Piletilevi, EventProvider::Ticketpro, EventProvider::FBI]
    end
  end

  context "#process_new_events" do
    it "sends out e-mail for new events" do
      new_events = [
        EventProvider::Base.new(id: "123", title: "foo", link: "http://example.org"),
        EventProvider::Base.new(id: "456", title: "bar", link: "http://example.org")
      ]
      eventify = Eventify.new
      eventify.should_receive(:new_events).and_return(new_events)
      eventify.should_receive(:send_email).with(new_events)

      eventify.process_new_events
    end

    it "does not send e-mail when no new events" do
      eventify = Eventify.new
      eventify.should_receive(:new_events).and_return([])
      eventify.should_not_receive(:send_email)

      eventify.process_new_events
    end

    it "saves new events into database" do
      new_events = [
        EventProvider::Base.new(id: "123", title: "foo", link: "http://example.org/1", date: Time.now),
        EventProvider::Base.new(id: "456", title: "bar", link: "http://example.org/2", date: Time.now)
      ]
      eventify = Eventify.new
      eventify.should_receive(:new_events).and_return(new_events)
      eventify.stub(:send_email)

      eventify.process_new_events

      Db.events.size.should == 2
    end
  end

  it "#send_email" do
    eventify = Eventify.new
    ::Mail.should_receive(:deliver)

    eventify.send_email([])
  end

  it "#format_for_email" do
    new_events = [
      EventProvider::Base.new(id: "123", title: "foo", link: "http://example.org/1", date: Time.now),
      EventProvider::Piletilevi.new(id: "456", title: "bar", link: "http://example.org/2", date: Time.now),
      EventProvider::Base.new(id: "456", title: "bar3", link: "http://example.org/3", date: Time.now)
    ]

    eventify = Eventify.new
    eventify.format_for_email(new_events).should == "There are some rumours going on about 3 possible awesome events:

* bar
    http://example.org/2

* bar3
    http://example.org/3

* foo
    http://example.org/1

Your Humble Servant,
Eventify"
  end
end
