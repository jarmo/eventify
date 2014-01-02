require File.expand_path("event_provider/base", __dir__)
require File.expand_path("event_provider/fbi", __dir__)
require File.expand_path("event_provider/piletilevi", __dir__)
require File.expand_path("event_provider/ticketpro", __dir__)
require File.expand_path("db", __dir__)
require File.expand_path("eventify_mailer", __dir__)

class Eventify
  def all_events
    @all_events ||= providers.flat_map(&:fetch).uniq
  end

  def new_events
    @new_events ||= all_events.reject(&:exists?)
  end

  def process_new_events
    all_new_events = new_events
    return if all_new_events.empty?

    EventifyMailer.deliver all_new_events
    all_new_events.each(&:save)
  end

  def providers
    [EventProvider::Piletilevi, EventProvider::Ticketpro, EventProvider::FBI]
  end
end
