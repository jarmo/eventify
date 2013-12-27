require "simple-rss"
require "open-uri"

module Event
  class Ticketpro < Base
    URL = "http://www.ticketpro.ee/jnp/rss/index.xml" 

    class << self
      def fetch
        rss = SimpleRSS.parse open(URL)
        rss.entries.map { |entry| new id: entry.guid, title: entry.title, link: entry.link, date: entry.pubDate }
      end
    end
  end
end
