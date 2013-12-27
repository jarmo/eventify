require "simple-rss"
require "open-uri"
require "event/base"

module Event
  class Piletilevi < Base
    MUSIC_URL = "http://www.piletilevi.ee/category.rss.php?path=est/piletid/muusika"

    class << self
      def fetch
        rss = SimpleRSS.parse open(MUSIC_URL)
        rss.entries.map { |entry| {title: entry.title, link: entry.link, date: entry.pubDate, id: entry.guid} }
      end
    end
  end
end
