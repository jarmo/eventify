require "open-uri"
require "nokogiri"

module Eventify::Provider
  class SolarisKino < Base
    URL = "http://solariskino.ee/" 

    class << self
      def fetch
        doc = Nokogiri::HTML(open(URL))
        doc.search("#tab-2 .quickSchedule-item .title a").map do |a|
          url = URI.join(URL, a["href"]).to_s
          movie_info = Nokogiri::HTML(open(url)).at(".movie-info")

          new id: url, title: "#{movie_info.at("h2").content}/#{movie_info.at(".title-original").content}", link: url, date: Time.now
        end
      end
    end
  end
end
