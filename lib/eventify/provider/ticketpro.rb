require "simple-rss"
require "open-uri"

module Eventify::Provider
  class Ticketpro < Base
    URL = "http://www.ticketpro.ee/jnp/rss/index.xml" 

    class << self
      def fetch
        rss = SimpleRSS.parse open(URL)
        rss.entries.map { |entry| new id: entry.guid, title: entry.title, link: entry.link, date: entry.pubDate }
      end
    end

    alias_method :_id, :id

    def id
      _id.gsub(%r{/jnp/(ru|en)/}, "/jnp/")
    end
  end
end
