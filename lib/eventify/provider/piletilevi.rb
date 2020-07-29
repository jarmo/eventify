require "faraday"
require "json"

module Eventify::Provider
  class Piletilevi < Base
    URL = URI.parse("https://www.piletilevi.ee/ajaxCaller/method:getConcertsListInfo/id:1089/type:catalog_category")

    class << self
      def fetch
        json = JSON.parse(Faraday.new(url: "#{URL.scheme}://#{URL.host}").get(URL.path).body, symbolize_names: true) rescue {}
        entries = json[:responseData] && json[:responseData][:event] || []
        entries.map do |entry|
          new id: entry[:id], title: entry[:title], link: entry[:link], date: Time.at(entry[:startTime][:stamp])
        end
      end
    end
  end
end
