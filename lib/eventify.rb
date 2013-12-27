require File.expand_path("event/base", __dir__)
require File.expand_path("event/piletilevi", __dir__)
require File.expand_path("event/ticketpro", __dir__)
require File.expand_path("db", __dir__)

class Eventify
  def all_events
    @all_events ||= providers.flat_map(&:fetch)
  end

  def new_events
    all_events.reject(&:exists?)
  end

  def providers
    [Event::Piletilevi, Event::Ticketpro]
  end
end

if $PROGRAM_NAME == __FILE__
  require "rufus-scheduler"
  require File.expand_path("eventify_scheduler", __dir__)

  scheduler = Rufus::Scheduler.new
  scheduler.every("15m", EventifyScheduler, first_in: Time.now)

  scheduler.join
end
