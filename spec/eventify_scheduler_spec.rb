require "spec_helper"
require File.expand_path("../lib/eventify_scheduler", __dir__)

describe EventifyScheduler do
  it "#call invokes #perform" do
    scheduler = EventifyScheduler.new
    scheduler.should_receive(:perform)

    scheduler.call nil
  end
end
