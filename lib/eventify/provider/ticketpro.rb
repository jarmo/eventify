require "simple-rss"
require "open-uri"

module Eventify::Provider
  class Ticketpro < Base
    URL = "http://www.ticketpro.ee/jnp/rss/index.xml" 

    class << self
      def fetch
        rss = open(URL) { |f| SimpleRSS.parse f.read.encode("UTF-8").force_encoding("UTF-8") }
        rss.entries.map { |entry| new id: entry.guid, title: entry.title, link: entry.link, date: entry.pubDate }
      end
    end
  end
end
