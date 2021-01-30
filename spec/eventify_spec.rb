require "spec_helper"

describe Eventify do
  before do
    stub_const "Eventify::Configuration::PATH", File.join(Dir.tmpdir, "eventify-config.yml")
    File.delete Eventify::Configuration::PATH if File.exists? Eventify::Configuration::PATH
  end

  context "#initialize" do
    it "initializes configuration" do
      expect(Eventify.new.configuration[:subscribers]).to eq(["user@example.org"])
    end

    it "allows to override configuration" do
      expect(Eventify.new(foo: "bar").configuration[:foo]).to eq("bar")
    end
  end

  context "#configuration" do
    it "provides access to the configuration instance" do
      eventify = Eventify.new
      expect(eventify.configuration).to eq(eventify.instance_variable_get(:@configuration))
    end
  end

  context "#new_events" do
    it "all are new" do
      eventify = Eventify.new
      events = [
        Eventify::Provider::Base.new(id: "123", title: "foo", link: "http://example.org"),
        Eventify::Provider::Base.new(id: "456", title: "bar", link: "http://example.org")
      ]
      allow(eventify).to receive_messages(all_events: events)
      expect(eventify.new_events).to eq(events)
    end

    it "old ones are filtered out" do
      eventify = Eventify.new
      old_event = Eventify::Provider::Base.new(id: "123", title: "foo", link: "http://example.org").save
      new_event = Eventify::Provider::Base.new(id: "456", title: "bar", link: "http://example.org")
      events = [old_event, new_event]
      allow(eventify).to receive_messages(all_events: events)

      expect(eventify.new_events).to eq([new_event])
    end

    it "caches the results" do
      eventify = Eventify.new

      event = Eventify::Provider::Base.new(id: "123", title: "foo", link: "http://example.org")
      expect(eventify).to receive(:all_events).and_return([event])

      2.times { expect(eventify.new_events).to eq([event]) }
    end
  end

  context "#all_events" do
    it "fetches all events from all providers" do
      eventify = Eventify.new
      eventify.providers.each do |provider|
        expect(provider).to receive :fetch
      end

      eventify.all_events
    end

    it "combines all events from all providers" do
      event1 = Eventify::Provider::Piletilevi.new(id: "123", title: "foo", link: "http://example.org")
      event2 = Eventify::Provider::Piletilevi.new(id: "456", title: "bar", link: "http://example.org")
      allow(Eventify::Provider::Piletilevi).to receive_messages(fetch: [event1, event2])

      event3 = Eventify::Provider::Base.new(id: "123", title: "foo", link: "http://example.org")
      allow(Eventify::Provider::Base).to receive_messages(fetch: [event3])

      eventify = Eventify.new
      allow(eventify).to receive_messages(providers: [Eventify::Provider::Piletilevi, Eventify::Provider::Base])
      expect(eventify.all_events).to eq([event1, event2, event3])
    end

    it "caches results" do
      eventify = Eventify.new
      expect(eventify).to receive(:providers).once.and_return([Eventify::Provider::Base])
      expect(Eventify::Provider::Base).to receive(:fetch).once.and_return([1])

      expect(eventify.all_events).to eq([1])
      expect(eventify.all_events).to eq([1])
    end

    it "removes duplicate entries" do
      event1 = Eventify::Provider::Piletilevi.new(id: "123", title: "foo", link: "http://example.org")
      event2 = Eventify::Provider::Piletilevi.new(id: "123", title: "foo", link: "http://example.org")
      expect(event1).to eq(event2)
      allow(Eventify::Provider::Piletilevi).to receive_messages(fetch: [event1, event2])

      eventify = Eventify.new
      allow(eventify).to receive_messages(providers: [Eventify::Provider::Piletilevi])
      expect(eventify.all_events).to eq([event1])
    end
  end

  context "#providers" do
    it "returns all providers" do
      expected_providers = [
        Eventify::Provider::Piletilevi,
        Eventify::Provider::Livenation,
        Eventify::Provider::ApolloKino
      ]
      expect(Eventify.new.providers).to eq(expected_providers)
    end
    
    it "allows to override" do
      eventify = Eventify.new
      eventify.providers = ["foo"]

      expect(eventify.providers).to eq(["foo"])
    end
  end

  context "#process_new_events" do
    it "sends out e-mail for new events" do
      new_events = [
        Eventify::Provider::Base.new(id: "123", title: "foo", link: "http://example.org"),
        Eventify::Provider::Base.new(id: "456", title: "bar", link: "http://example.org")
      ]
      configuration = double("configuration")
      eventify = Eventify.new configuration
      expect(eventify).to receive(:new_events).and_return(new_events)
      expect(Eventify::Mail).to receive(:deliver).with(new_events, configuration)

      eventify.process_new_events
    end

    it "does not send e-mail when no new events" do
      eventify = Eventify.new
      expect(eventify).to receive(:new_events).and_return([])
      expect(Eventify::Mail).not_to receive(:deliver)

      eventify.process_new_events
    end

    it "saves new events into database" do
      new_events = [
        Eventify::Provider::Base.new(id: "123", title: "foo", link: "http://example.org/1", date: Time.now),
        Eventify::Provider::Base.new(id: "456", title: "bar", link: "http://example.org/2", date: Time.now)
      ]
      eventify = Eventify.new
      expect(eventify).to receive(:new_events).and_return(new_events)
      allow(Eventify::Mail).to receive(:deliver)

      eventify.process_new_events

      expect(Eventify::Database.events.size).to eq(2)
    end
  end
end
