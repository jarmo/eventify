require File.expand_path("eventify/version", __dir__)
require File.expand_path("eventify/configuration", __dir__)
require File.expand_path("eventify/provider/base", __dir__)
require File.expand_path("eventify/provider/fbi", __dir__)
require File.expand_path("eventify/provider/piletilevi", __dir__)
require File.expand_path("eventify/provider/ticketpro", __dir__)
require File.expand_path("eventify/database", __dir__)
require File.expand_path("eventify/mail", __dir__)

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

    Eventify::Mail.deliver all_new_events
    all_new_events.each(&:save)
  end

  attr_writer :providers

  def providers
    @providers ||= [Eventify::Provider::Piletilevi, Eventify::Provider::Ticketpro, Eventify::Provider::FBI]
  end
end
