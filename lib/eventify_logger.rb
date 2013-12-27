require "logger"
require "singleton"

class EventifyLogger
  include Singleton

  attr_reader :logger

  def initialize
    @logger = Logger.new(File.expand_path("../eventify.log", __dir__))
  end

  class << self
    def debug(message)
      instance.logger.debug(message.respond_to?(:call) ? message.call : message) if enabled?
    end

    def enabled?
      not defined? RSpec
    end
  end
end
