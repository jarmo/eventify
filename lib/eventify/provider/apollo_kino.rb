require "open-uri"
require "nokogiri"
require "time"

module Eventify::Provider
  class ApolloKino < Base
    URL = "https://www.apollokino.ee/eng/movies?3064-actionType=1" 

    class << self
      def fetch
        doc = Nokogiri::HTML(URI.open(URL))
        doc.search(".schedule__item").map do |item|
          title_node = item.at(".movie-card__title a")
          url = title_node["href"]
          date = Time.strptime(item.at(".movie-card__label").content.gsub(/In Cinemas /, ""), "%m/%d/%Y")
          new id: url, title: title_node.content, link: url, date: date
        end
      end
    end
  end
end
