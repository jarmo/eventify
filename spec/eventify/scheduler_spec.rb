require "spec_helper"
require File.expand_path("../../lib/eventify/scheduler", __dir__)

describe Eventify::Scheduler do
  before do
    Eventify::Scheduler.any_instance.stub(:L)
  end

  it "#call invokes Eventify#process_new_events" do
    Eventify.any_instance.should_receive(:process_new_events)

    Eventify::Scheduler.new.call nil
  end
end
