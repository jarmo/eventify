require "simple-rss"
require "open-uri"

module Eventify::Provider
  class Ticketpro < Base
    URL = "http://www.ticketpro.ee/jnp/rss/index.xml" 

    def initialize(event)
      super
      @id = @id.gsub(%r{/jnp/(ru|en)/}, "/jnp/")
      @link = @link.gsub(%r{/jnp/(ru|en)/}, "/jnp/")
    end

    class << self
      def fetch
        rss = SimpleRSS.parse open(URL)
        rss.entries.map { |entry| new id: entry.guid, title: entry.title, link: entry.link, date: entry.pubDate }
      end
    end
  end
end
