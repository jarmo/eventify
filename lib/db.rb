require "sqlite3"

class Db
  DATABASE_NAME = "db/eventify.db"

  class << self
    def exists?(event)
      results = sqlite.execute "select guid from event where guid=?", event[:guid]
      !results.empty?
    end

    def save(event)
      sqlite.execute "insert into event values(?, ?, ?, ?, ?)", 
        event[:guid],
        event[:provider],
        event[:date].to_s,
        event[:title],
        event[:link]
    end

    def events
      translated_events = []
      sqlite.execute("select * from event") do |event|
        translated_events << {
          guid: event["guid"],
          provider: event["provider"],
          title: event["title"],
          link: event["link"],
          date: Time.parse(event["date"])
        }
      end

      translated_events
    end

    private

    def sqlite
      @sqlite ||= begin
                    FileUtils.mkdir_p "db"
                    database = SQLite3::Database.new DATABASE_NAME
                    database.results_as_hash = true

                    database.execute "create table if not exists event(
                      guid primary key,
                      provider text,
                      date text,
                      title text,
                      link text
                    )"

                    database
                  end
    end
  end
end
