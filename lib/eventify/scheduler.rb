require "logger"
require File.expand_path("../eventify", __dir__)

class Eventify::Scheduler
  def call(_)
    L("Fetch events.")
    eventify = Eventify.new
    eventify.process_new_events
    L("Fetch done with #{eventify.new_events.size} new events out of #{eventify.all_events.size} events.")
  rescue Exception => e
    L("Fetch failed with an error \"#{e.message}\": #{e.backtrace.join("\n")}")
  end

  private

  def L(message)
    FileUtils.mkdir_p File.expand_path("../../logs", __dir__)
    @logger ||= Logger.new(File.expand_path("../../logs/eventify.log", __dir__))
    @logger.debug message
  end

end

if $PROGRAM_NAME == __FILE__
  require "rufus-scheduler"

  scheduler = Rufus::Scheduler.new
  scheduler.every("6h", Eventify::Scheduler, first_in: Time.now + 5)

  scheduler.join
end
