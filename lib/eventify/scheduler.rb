require "logger"

class Eventify::Scheduler
  def call(_)
    L("Fetch events.")
    eventify = Eventify.new
    eventify.process_new_events
    L("Fetch done with #{eventify.new_events.size} new events out of #{eventif.all_events} events.")
  rescue Exception => e
    L("Fetch failed with an error \"#{e.message}\": #{e.backtrace.join("\n")}")
  end

  private

  def L(message)
    @logger ||= Logger.new(File.expand_path("../eventify.log", __dir__))
    @logger.debug(message.respond_to?(:call) ? message.call : message)
  end

end

if $PROGRAM_NAME == __FILE__
  require "rufus-scheduler"
  require File.expand_path("eventify", __dir__)

  scheduler = Rufus::Scheduler.new
  scheduler.every("6h", Eventify::Scheduler, first_in: Time.now + 5)

  scheduler.join
end
