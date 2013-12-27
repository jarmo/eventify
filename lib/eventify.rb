require "event/base"
require "event/piletilevi"
require "db"

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
