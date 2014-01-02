require "logger"

class EventifyScheduler
  def call(_)
    L("Fetch events.")
    Eventify.new.process_new_events
    L("Fetch done.")
  rescue Exception => e
    L("Fetch failed with an error \"#{e.message}\": #{e.backtrace.join("\n")}")
  end

  private

  def L(message)
    @logger ||= Logger.new(File.expand_path("../eventify.log", __dir__))
    @logger.debug(message.respond_to?(:call) ? message.call : message)
  end

end
