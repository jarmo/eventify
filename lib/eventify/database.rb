require "sqlite3"

class Eventify::Database
  PATH = File.expand_path(File.join(ENV["HOME"], "/.eventify/events.sqlite3"))

  class << self
    def exists?(event)
      results = sqlite.execute "select 1 from event where id=? and provider=? and link=?", [event.id, event.provider, event.link]
      !results.empty?
    end

    def save(event)
      sqlite.execute "insert into event values(?, ?, ?, ?, ?)", 
        [event.id,
        event.provider,
        event.title,
        event.link,
        event.date.to_s]
    end

    def events
      translated_events = []
      sqlite.execute("select * from event") do |event|
        translated_events << const_get(event["provider"]).new(
          id: event["id"],
          title: event["title"],
          link: event["link"],
          date: Time.parse(event["date"])
        )
      end

      translated_events
    end

    private

    def sqlite
      @sqlite ||= begin
                    FileUtils.mkdir_p File.dirname(PATH)
                    database = SQLite3::Database.new PATH
                    database.results_as_hash = true

                    database.execute "create table if not exists event(
                      id text,
                      provider text,
                      title text,
                      link text,
                      date text,
                      primary key (id, provider, link)
                    )"

                    database
                  end
    end
  end
end
