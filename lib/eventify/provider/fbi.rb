require "open-uri"
require "nokogiri"

module Eventify::Provider
  class FBI < Base
    URL = "http://www.fbi.ee/" 

    class << self
      def fetch
        doc = Nokogiri::HTML(open(URL))
        doc.search(".article-list li h2 a").map do |a|
          new id: a["href"], title: a.content, link: a["href"], date: Time.now
        end
      end
    end
  end
end
