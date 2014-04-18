require "open-uri"
require "nokogiri"

module Eventify::Provider
  class SolarisKino < Base
    URL = "http://solariskino.ee/" 

    class << self
      def fetch
        doc = Nokogiri::HTML(open(URL))
        doc.search("#tab-2 .quickSchedule-item").map do |tr|
          title = tr.at(".title a")
          url = URI.join(URL, title["href"]).to_s
          new id: url, title: "#{title.content} (#{tr.at(".date span").content})", link: url, date: Time.now
        end
      end
    end
  end
end
