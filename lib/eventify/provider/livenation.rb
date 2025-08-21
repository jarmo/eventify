require "open-uri"
require "json"
require "time"

module Eventify::Provider
  class Livenation < Base
    URL = "https://www.livenation.ee/api/search/events?IncludePostponed=true&IncludeCancelled=false&Url=%2Fevent%2Fallevents&PageSize=200&Page=1&CountryIds=68"

    class << self
      def fetch
        json = JSON.parse(URI.open(URL).read)
        entries = json["documents"]
        entries.map do |entry|
          localization = entry["localizations"][0]
          url = URI.parse(localization["url"])
          url = URI.parse("https://www.livenation.ee#{url}") unless url.host
          new id: entry["id"], title: localization["name"], link: url.to_s, date: Time.parse(entry["eventDate"])
        end
      end
    end
  end
end
