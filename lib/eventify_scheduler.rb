class EventifyScheduler
  def call(_)
    perform
  end

  private

  def perform
    new_events = Eventify.new.new_events
    send_emails new_events
  end

  def send_emails(new_events)

  end
end
