class Eventify
  module Provider
    class Base
      include Comparable

      class << self
        def fetch
          raise NotImplementedError
        end
      end

      attr_reader :id, :title, :link, :date

      def initialize(event)
        @id = event[:id] or raise MissingAttributeError.new("id is missing")
        @title = event[:title] or raise MissingAttributeError.new("title is missing")
        @link = event[:link] or raise MissingAttributeError.new("link is missing")
        @date = event[:date]
      end

      def provider
        @provider ||= self.class.name
      end

      def save
        Database.save self 
        self
      end

      def exists?
        Database.exists? self
      end

      def ==(other)
        id == other.id &&
          provider == other.provider &&
          title == other.title &&
          link == other.link &&
          date.to_i == other.date.to_i
      end

      alias_method :eql?, :==

      def hash
        "#{id}-#{provider}-#{title}-#{link}-#{date.to_i}".hash
      end

      def <=>(other)
        title <=> other.title
      end

      MissingAttributeError = Class.new(RuntimeError)
    end
  end
end
