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
      new_events = [Event::Base.new(id: "123"), Event::Base.new(id: "456")]
      Eventify.any_instance.should_receive(:new_events).and_return(new_events)
      
      scheduler = EventifyScheduler.new
      scheduler.should_receive(:send_email).with(new_events)

      scheduler.send(:perform)
    end
  end
end
