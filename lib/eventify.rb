require File.expand_path("event_provider/base", __dir__)
require File.expand_path("event_provider/fbi", __dir__)
require File.expand_path("event_provider/piletilevi", __dir__)
require File.expand_path("event_provider/ticketpro", __dir__)
require File.expand_path("db", __dir__)

class Eventify
  def all_events
    @all_events ||= providers.flat_map(&:fetch)
  end

  def new_events
    all_events.reject(&:exists?)
  end

  def providers
    [EventProvider::Piletilevi, EventProvider::Ticketpro, EventProvider::FBI]
  end
end

if $PROGRAM_NAME == __FILE__
  require "rufus-scheduler"
  require File.expand_path("eventify_scheduler", __dir__)

  scheduler = Rufus::Scheduler.new
  scheduler.every("1h", EventifyScheduler, first_in: Time.now)

  scheduler.join
end
