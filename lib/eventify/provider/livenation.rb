require "open-uri"
require "nokogiri"
require "json"
require "time"

module Eventify::Provider
  class Livenation < Base
    URL = "https://www.livenation.ee/event/allevents" 

    class << self
      def fetch
        doc = Nokogiri::HTML(open(URL))
        doc.search("script[type='application/ld+json']").map do |raw_item|
          item = JSON.parse(raw_item.content)
          next unless item["name"]
          new id: item["url"], title: item["name"], link: item["url"], date: Time.parse(item["startDate"])
        end.compact
      end
    end
  end
end
