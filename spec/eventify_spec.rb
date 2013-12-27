require "spec_helper"

describe Eventify do
  context "#new_events" do
    it "all are new" do
      eventify = Eventify.new
      events = [Event::Base.new(id: "123"), Event::Base.new(id: "456")]
      eventify.stub(fetch_all: events)
      eventify.new_events.should == events
    end

    it "old ones are filtered out" do
      eventify = Eventify.new
      old_event = Event::Base.new(id: "123").save
      new_event = Event::Base.new(id: "456")
      events = [old_event, new_event]
      eventify.stub(fetch_all: events)
      eventify.new_events.should == [new_event]
    end
  end

  context "#fetch_all" do
    it "fetches all events from all providers" do
      eventify = Eventify.new
      Event::Piletilevi.should_receive :fetch

      eventify.fetch_all
    end

    it "combines all events from all providers" do
      event1 = Event::Piletilevi.new(id: "123")
      event2 = Event::Piletilevi.new(id: "456")
      Event::Piletilevi.stub(fetch: [event1, event2])

      event3 = Event::Base.new(id: "123")
      Event::Base.stub(fetch: [event3])

      eventify = Eventify.new
      eventify.stub(providers: [Event::Piletilevi, Event::Base])
      eventify.fetch_all.should == [event1, event2, event3]
    end

    it "caches results" do
      eventify = Eventify.new
      eventify.should_receive(:providers).once.and_return([Event::Base])
      Event::Base.should_receive(:fetch).once.and_return([1])

      eventify.fetch_all.should == [1]
      eventify.fetch_all.should == [1]
    end
  end

  context "#providers" do
    it "returns all providers" do
      Eventify.new.providers.should == [Event::Piletilevi]
    end
  end
end
