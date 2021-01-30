require "open-uri"
require "json"

module Eventify::Provider
  class Piletilevi < Base
    URL = URI.parse("https://www.piletilevi.ee/ajaxCaller/method:getConcertsListInfo/id:1089/type:catalog_category/order:date,asc")

    class << self
      def fetch
        first_page_json = fetch_page(1)
        list_info = first_page_json["responseData"]["listInfo"]
        total_pages = list_info["total"] / list_info["pageSize"] + 1
        result = events(first_page_json) + (2..total_pages).flat_map { |page_number| events(fetch_page(page_number)) }
        result
      end

      private
      
      def fetch_page(number)
        JSON.parse(open("#{URL}/page:#{number}").read)
      end

      def events(json)
        entries = json["responseData"]["event"]
        entries.map do |entry|
          new id: entry["id"], title: entry["title"], link: entry["link"], date: Time.at(entry["startTime"]["stamp"])
        end
      end
    end
  end
end
