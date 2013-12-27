require "event/base"
require "event/piletilevi"
require "db"

class Eventify
  def fetch_all
    providers.each &:fetch
  end

  def new_events
    fetch_all.delete_if &:exists?
  end

  def providers
    [Event::Piletilevi]
  end
end
