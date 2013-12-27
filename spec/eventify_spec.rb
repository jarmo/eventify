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
  end

  context "#providers" do
    it "returns all providers" do
      Eventify.new.providers.should == [EventProvider::Piletilevi, EventProvider::Ticketpro, EventProvider::FBI]
    end
  end
end
