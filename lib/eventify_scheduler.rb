require "mail"

class EventifyScheduler
  def call(_)
    perform
  end

  private

  def perform
    new_events = Eventify.new.new_events
    send_email new_events
    new_events.each(&:save)
  end

  def send_email(new_events)
    ::Mail.deliver do
      delivery_method :smtp, {:address => "mail.neti.ee", :domain => "neti.ee",
                              :port => 25, :openssl_verify_mode => "none"}

      to "jarmo.p@gmail.com"
      from "no-reply@eventify.com"
      subject "New events!"
      body format_for_email(new_events)
    end
  end

  def format_for_email(events)
    header = "There might be some awesome events coming towards you:"
    footer = "Until next time :)"

    formatted_events = events.sort.reduce([header, ""]) do |memo, event|
      memo << "- #{event.title} (#{event.link})"
    end

    formatted_events << "" << footer
    formatted_events.join("\n")
  end
end
