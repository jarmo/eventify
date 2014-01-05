require "simple-rss"
require "open-uri"

module Eventify::Provider
  class Piletilevi < Base
    # http://www.piletilevi.ee/est/uldinfo/rss
    URLS = [
      "http://www.piletilevi.ee/news.rss.php?path=est/uudised",
      "http://www.piletilevi.ee/news.rss.php?path=est/teatriuudised",
      "http://www.piletilevi.ee/news.rss.php?path=est/muudatused",
      "http://www.piletilevi.ee/category.rss.php?path=est/piletid/muusika",
      # 404?
      #"http://www.piletilevi.ee/category.rss.php?path=est/piletid/teater_-_kunst",
      "http://www.piletilevi.ee/category.rss.php?path=est/piletid/kogupere",
      "http://www.piletilevi.ee/category.rss.php?path=est/piletid/sport",
      "http://www.piletilevi.ee/category.rss.php?path=est/piletid/festival",
      "http://www.piletilevi.ee/category.rss.php?path=est/piletid/film",
      "http://www.piletilevi.ee/category.rss.php?path=est/piletid/kinkekaardid",
      "http://www.piletilevi.ee/category.rss.php?path=est/piletid/varia"
    ]

    class << self
      def fetch
        URLS.each.reduce([]) do |memo, url|
          rss = open(url) { |f| SimpleRSS.parse f.read.encode("UTF-8").force_encoding("UTF-8") }
          memo + rss.entries.map { |entry| new id: entry.guid, title: entry.title, link: entry.link, date: entry.pubDate }
        end
      end
    end
  end
end
