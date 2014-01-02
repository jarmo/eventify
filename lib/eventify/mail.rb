require "mail"

class Eventify::Mail
  class << self
    def deliver(new_events)
      formatted_events = format(new_events)

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

    def format(events)
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
  end
end
