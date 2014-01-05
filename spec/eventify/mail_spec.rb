require "spec_helper"

describe Eventify::Mail do
  context ".deliver" do
    it "sends e-mail to all subscribers" do
      ::Mail.should_receive(:deliver).twice

      Eventify::Mail.deliver([], Eventify::Configuration.new(subscribers: ["foo@example.org", "bar@example.org"]))
    end
  end

  it ".format" do
    new_events = [
      Eventify::Provider::Base.new(id: "123", title: "foo", link: "http://example.org/1", date: Time.now),
      Eventify::Provider::Piletilevi.new(id: "456", title: "bar", link: "http://example.org/2", date: Time.now),
      Eventify::Provider::Base.new(id: "456", title: "bar3", link: "http://example.org/3", date: Time.now)
    ]

    Eventify::Mail.format(new_events).should == "There are some rumours going on about 3 possible awesome events:

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
