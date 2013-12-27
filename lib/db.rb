require "sqlite3"

class Db
  DATABASE_PATH = File.expand_path("../db/eventify.db", __dir__)

  class << self
    def exists?(event)
      results = sqlite.execute "select 1 from event where id=? and provider=?", event.id, event.provider
      !results.empty?
    end

    def save(event)
      sqlite.execute "insert into event values(?, ?, ?, ?, ?)", 
        event.id,
        event.provider,
        event.date.to_s,
        event.title,
        event.link
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
                    FileUtils.mkdir_p "db"
                    database = SQLite3::Database.new DATABASE_PATH
                    database.results_as_hash = true

                    database.execute "create table if not exists event(
                      id text,
                      provider text,
                      date text,
                      title text,
                      link text,
                      primary key (id, provider)
                    )"

                    database
                  end
    end
  end
end
