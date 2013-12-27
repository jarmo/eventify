# encoding: utf-8

require "mail"
require "logger"

class EventifyScheduler
  def call(_)
    L("Fetching events.")
    perform
    L("Fetching done.")
  end

  private

  def perform
    eventify = Eventify.new
    new_events = eventify.new_events
    L(proc {"Fetched #{eventify.all_events.size}, out of which #{new_events.size} are new."})
    return if new_events.empty?

    send_email new_events
    L("Email sent.")

    new_events.each do |event|
      begin
        event.save
      rescue SQLite3::ConstraintException
        L("Failed to save event: #{event.inspect}")
      end
    end
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
end
