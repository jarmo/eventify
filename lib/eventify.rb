require "event/base"
require "event/piletilevi"
require "db"

class Eventify
  def new_events
    fetch_all.delete_if &:exists?
  end
end
