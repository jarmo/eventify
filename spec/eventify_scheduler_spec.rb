require "spec_helper"
require File.expand_path("../lib/eventify_scheduler", __dir__)

describe EventifyScheduler do
  it "#call invokes #perform" do
    scheduler = EventifyScheduler.new
    scheduler.should_receive(:perform)

    scheduler.call nil
  end

  context "#perform" do
    it "sends out e-mail for new events" do
      new_events = [
        Event::Base.new(id: "123", title: "foo", link: "http://example.org"),
        Event::Base.new(id: "456", title: "bar", link: "http://example.org")
      ]
      Eventify.any_instance.should_receive(:new_events).and_return(new_events)

      scheduler = EventifyScheduler.new
      scheduler.should_receive(:send_email).with(new_events)

      scheduler.send(:perform)
    end

    it "does not send e-mail when no new events" do
      Eventify.any_instance.should_receive(:new_events).and_return([])

      scheduler = EventifyScheduler.new
      scheduler.should_not_receive(:send_email)

      scheduler.send(:perform)
    end

    it "saves new events into database" do
      new_events = [
        Event::Base.new(id: "123", title: "foo", link: "http://example.org/1", date: Time.now),
        Event::Base.new(id: "456", title: "bar", link: "http://example.org/2", date: Time.now)
      ]
      Eventify.any_instance.should_receive(:new_events).and_return(new_events)

      scheduler = EventifyScheduler.new
      scheduler.stub(:send_email)

      scheduler.send(:perform)

      Db.events.size.should == 2
    end
  end

  it "#send_email" do
    scheduler = EventifyScheduler.new
    ::Mail.should_receive(:deliver)

    scheduler.send(:send_email, [])
  end

  it "#format_for_email" do
    new_events = [
      Event::Base.new(id: "123", title: "foo", link: "http://example.org/1", date: Time.now),
      Event::Piletilevi.new(id: "456", title: "bar", link: "http://example.org/2", date: Time.now),
      Event::Base.new(id: "456", title: "bar3", link: "http://example.org/3", date: Time.now)
    ]


    scheduler = EventifyScheduler.new
    scheduler.send(:format_for_email, new_events).should == "There are some rumours going on about 3 possible awesome events:

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
