require "open-uri"
require "nokogiri"

module Eventify::Provider
  class SolarisKino < Base
    URL = "http://solariskino.ee/" 

    class << self
      def fetch
        doc = Nokogiri::HTML(open(URI.join(URL, "et/tulemas/")))
        poster_movie = movie doc.at(".info")

        other_movies = doc.search(".item").map do |div|
          movie div
        end

        [poster_movie].concat other_movies
      end

      private

      def movie(node)
        link = node.at("h2 a")        
        title = "#{link.content}/#{node.at(".original-title").content}"

        new id: title, title: title, link: URI.join(URL, link["href"]).to_s, date: Time.now
      end
    end
  end
end
