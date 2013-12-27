require "mail"

class EventifyScheduler
  def call(_)
    perform
  end

  private

  def perform
    new_events = Eventify.new.new_events
    send_email new_events
  end

  def send_email(new_events)
    ::Mail.deliver do
      delivery_method :smtp, {:address => "mail.neti.ee", :domain => "neti.ee",
                              :port => 25, :openssl_verify_mode => "none"}

      to "jarmo.p@gmail.com"
      from "no-reply@eventify.com"
      subject "New events!"
      body new_events.first.link
    end
  end
end
