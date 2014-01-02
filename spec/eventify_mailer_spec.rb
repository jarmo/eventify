require "spec_helper"

describe EventifyMailer do
  it ".deliver" do
    ::Mail.should_receive(:deliver)

    EventifyMailer.deliver([])
  end

  it ".format" do
    new_events = [
      Eventify::Provider::Base.new(id: "123", title: "foo", link: "http://example.org/1", date: Time.now),
      Eventify::Provider::Piletilevi.new(id: "456", title: "bar", link: "http://example.org/2", date: Time.now),
      Eventify::Provider::Base.new(id: "456", title: "bar3", link: "http://example.org/3", date: Time.now)
    ]

    EventifyMailer.format(new_events).should == "There are some rumours going on about 3 possible awesome events:

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
