require File.expand_path("event/base", __dir__)
require File.expand_path("event/piletilevi", __dir__)
require File.expand_path("db", __dir__)

class Eventify
  def fetch_all
    @all_events ||= providers.flat_map(&:fetch)
  end

  def new_events
    fetch_all.delete_if(&:exists?)
  end

  def providers
    [Event::Piletilevi]
  end
end

if $PROGRAM_NAME == __FILE__
  require "rufus-scheduler"
  require File.expand_path("eventify_scheduler", __dir__)

  scheduler = Rufus::Scheduler.new
  scheduler.every("15m", EventifyScheduler, first_in: Time.now)

  scheduler.join
end
