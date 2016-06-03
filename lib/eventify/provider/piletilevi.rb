require "faraday"
require "json"

module Eventify::Provider
  class Piletilevi < Base
    URL = URI.parse("http://www.piletilevi.ee/ajaxCaller/method:getConcertsList/start:0/limit:500/id:58103/type:any/")

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
