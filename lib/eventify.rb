require "mail"
require "logger"
require File.expand_path("event_provider/base", __dir__)
require File.expand_path("event_provider/fbi", __dir__)
require File.expand_path("event_provider/piletilevi", __dir__)
require File.expand_path("event_provider/ticketpro", __dir__)
require File.expand_path("db", __dir__)

class Eventify
  def all_events
    @all_events ||= providers.flat_map(&:fetch).uniq
  end

  def new_events
    all_events.reject(&:exists?)
  end

  def process_new_events
    all_new_events = new_events
    L(proc {"Fetched #{all_events.size} events, out of which #{all_new_events.size} are new."})
    return if all_new_events.empty?

    send_email all_new_events
    L("Email sent.")

    all_new_events.each(&:save)
    L("New events saved.")
  end

  def send_email(new_events)
    formatted_events = format_for_email(new_events)

    ::Mail.deliver do
      delivery_method :smtp, {:address => "mail.neti.ee", :domain => "neti.ee",
                              :port => 25, :openssl_verify_mode => "none"}

      content_type "text/plain; charset=utf-8"

      to "jarmo.p@gmail.com"
      from "no-reply@eventify.io"
      subject "Event Rumours"
      body formatted_events
    end
  end

  def format_for_email(events)
    header = "There are some rumours going on about #{events.size} possible awesome events:"

    formatted_events = events.sort.reduce([header, ""]) do |memo, event|
      memo << "* #{event.title}".force_encoding("UTF-8")
      memo << "    #{event.link}"
      memo << ""
    end

    footer = "Your Humble Servant,\nEventify"

    formatted_events << footer
    formatted_events.join("\n")
  end

  def L(message)
    return if defined? RSpec

    @logger ||= Logger.new(File.expand_path("../eventify.log", __dir__))
    @logger.debug(message.respond_to?(:call) ? message.call : message)
  end

  def providers
    [EventProvider::Piletilevi, EventProvider::Ticketpro, EventProvider::FBI]
  end
end
