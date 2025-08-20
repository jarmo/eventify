require "open-uri"
require "json"

module Eventify::Provider
  class Piletilevi < Base
    URL = URI.parse("https://www.piletilevi.ee/api/v1/events?language=et&page=:PAGE:&pageSize=36&sortBy=date&sortOrder=ASC")
    EVENT_BASE_URL = URI.parse("https://www.piletilevi.ee/piletid/:ID:/:SLUG:")

    class << self
      def fetch
        first_page_json = fetch_page(1)
        total_pages = first_page_json["totalPages"]
        result = events(first_page_json) + (2..total_pages).flat_map { |page_number| events(fetch_page(page_number)) }
        result
      end

      private
      
      def fetch_page(number)
        JSON.parse(URI.open(URL.to_s.gsub(":PAGE:", number.to_s)).read)
      end

      def events(json)
        entries = json["items"]
        entries.map do |entry|
          link = URI.parse(EVENT_BASE_URL.to_s.gsub(":ID:", entry["id"]).gsub(":SLUG:", entry["sluggedName"]))
          new id: entry["id"], title: entry["name"], link: link.to_s, date: Time.at(entry["eventStartAt"])
        end
      end
    end
  end
end
