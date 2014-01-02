require "spec_helper"
require File.expand_path("../lib/eventify_scheduler", __dir__)

describe EventifyScheduler do
  it "#call invokes Eventify#process_new_events" do
    Eventify.any_instance.should_receive(:process_new_events)

    EventifyScheduler.new.call nil
  end
end
