require "mail"

class Eventify::Mail
  class << self
    def deliver(new_events, configuration)
      formatted_events = format(new_events)

      configuration[:subscribers].each do |subscriber|
        ::Mail.deliver do
          delivery_method :smtp, configuration[:mail]

          content_type "text/plain; charset=utf-8"

          to subscriber
          from "no-reply@eventify.io"
          subject "Event Rumours"
          body formatted_events
        end
      end
    end

    def format(events)
      header = "There are some rumours going on about #{events.size} possible awesome events:"

      formatted_events = events.sort.reduce([header, ""]) do |memo, event|
        memo << "* #{event.title}".force_encoding("UTF-8")
        memo << "    #{event.link}".force_encoding("UTF-8")
        memo << ""
      end

      footer = "Your Humble Servant,\nEventify"

      formatted_events << footer
      formatted_events.join("\n")
    end
  end
end
