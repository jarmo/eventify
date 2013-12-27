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
  end
end
