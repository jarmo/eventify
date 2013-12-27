require "simple-rss"
require "open-uri"

module Event
  class Piletilevi
    MUSIC_URL = "http://www.piletilevi.ee/category.rss.php?path=est/piletid/muusika"

    def fetch
      rss = SimpleRSS.parse open(MUSIC_URL)
      rss.entries.map { |entry| {title: entry.title, link: entry.link, date: entry.pubDate, guid: entry.guid} }
    end
  end
end
