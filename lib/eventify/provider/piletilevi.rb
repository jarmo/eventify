require "faraday"
require "json"

module Eventify::Provider
  class Piletilevi < Base
    URL = URI.parse("http://www.piletilevi.ee/ajaxCaller/method:getConcertsList/start:0/limit:500/id:58103/type:any/")

    class << self
      def fetch
        json = JSON.parse(Faraday.new(url: "#{URL.scheme}://#{URL.host}").get(URL.path).body) rescue {}
        entries = json["responseData"] && json["responseData"]["concert"] || []
        entries.map do |entry|
          new id: entry["id"], title: entry["title"], link: entry["link"], date: Time.at(entry["modifiedTimeStamp"].to_i)
        end
      end
    end
  end
end
