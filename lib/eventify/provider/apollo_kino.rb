require "open-uri"
require "nokogiri"
require "time"

module Eventify::Provider
  class ApolloKino < Base
    URL = "https://www.apollokino.ee/" 

    class << self
      def fetch
        doc = Nokogiri::HTML(open(URI.join(URL, "eng/soon")))
        doc.search(".EventList-container > div").map do |item|
          title_node = item.at("h2 a")
          url = URI.join(URL, title_node["href"]).to_s
          date = Time.strptime(item.at(".event-releaseDate b").content, "%d.%m.%Y")
          new id: url, title: title_node.content, link: url, date: date
        end
      end
    end
  end
end
