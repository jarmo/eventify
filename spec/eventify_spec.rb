require "spec_helper"

describe Eventify do
  context "#new_events" do
    it "all are new" do
      eventify = Eventify.new
      events = [
        Eventify::Provider::Base.new(id: "123", title: "foo", link: "http://example.org"),
        Eventify::Provider::Base.new(id: "456", title: "bar", link: "http://example.org")
      ]
      eventify.stub(all_events: events)
      eventify.new_events.should == events
    end

    it "old ones are filtered out" do
      eventify = Eventify.new
      old_event = Eventify::Provider::Base.new(id: "123", title: "foo", link: "http://example.org").save
      new_event = Eventify::Provider::Base.new(id: "456", title: "bar", link: "http://example.org")
      events = [old_event, new_event]
      eventify.stub(all_events: events)

      eventify.new_events.should == [new_event]
    end

    it "caches the results" do
      eventify = Eventify.new

      event = Eventify::Provider::Base.new(id: "123", title: "foo", link: "http://example.org")
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
      event1 = Eventify::Provider::Piletilevi.new(id: "123", title: "foo", link: "http://example.org")
      event2 = Eventify::Provider::Piletilevi.new(id: "456", title: "bar", link: "http://example.org")
      Eventify::Provider::Piletilevi.stub(fetch: [event1, event2])

      event3 = Eventify::Provider::Base.new(id: "123", title: "foo", link: "http://example.org")
      Eventify::Provider::Base.stub(fetch: [event3])

      eventify = Eventify.new
      eventify.stub(providers: [Eventify::Provider::Piletilevi, Eventify::Provider::Base])
      eventify.all_events.should == [event1, event2, event3]
    end

    it "caches results" do
      eventify = Eventify.new
      eventify.should_receive(:providers).once.and_return([Eventify::Provider::Base])
      Eventify::Provider::Base.should_receive(:fetch).once.and_return([1])

      eventify.all_events.should == [1]
      eventify.all_events.should == [1]
    end

    it "removes duplicate entries" do
      event1 = Eventify::Provider::Piletilevi.new(id: "123", title: "foo", link: "http://example.org")
      event2 = Eventify::Provider::Piletilevi.new(id: "123", title: "foo", link: "http://example.org")
      event1.should == event2
      Eventify::Provider::Piletilevi.stub(fetch: [event1, event2])

      eventify = Eventify.new
      eventify.stub(providers: [Eventify::Provider::Piletilevi])
      eventify.all_events.should == [event1]
    end
  end

  context "#providers" do
    it "returns all providers" do
      Eventify.new.providers.should == [Eventify::Provider::Piletilevi, Eventify::Provider::Ticketpro, Eventify::Provider::FBI]
    end
    
    it "allows to override" do
      eventify = Eventify.new
      eventify.providers = ["foo"]

      eventify.providers.should == ["foo"]
    end
  end

  context "#process_new_events" do
    it "sends out e-mail for new events" do
      new_events = [
        Eventify::Provider::Base.new(id: "123", title: "foo", link: "http://example.org"),
        Eventify::Provider::Base.new(id: "456", title: "bar", link: "http://example.org")
      ]
      eventify = Eventify.new
      eventify.should_receive(:new_events).and_return(new_events)
      Eventify::Mail.should_receive(:deliver).with(new_events)

      eventify.process_new_events
    end

    it "does not send e-mail when no new events" do
      eventify = Eventify.new
      eventify.should_receive(:new_events).and_return([])
      Eventify::Mail.should_not_receive(:deliver)

      eventify.process_new_events
    end

    it "saves new events into database" do
      new_events = [
        Eventify::Provider::Base.new(id: "123", title: "foo", link: "http://example.org/1", date: Time.now),
        Eventify::Provider::Base.new(id: "456", title: "bar", link: "http://example.org/2", date: Time.now)
      ]
      eventify = Eventify.new
      eventify.should_receive(:new_events).and_return(new_events)
      Eventify::Mail.stub(:deliver)

      eventify.process_new_events

      Eventify::Database.events.size.should == 2
    end
  end
end
