module EventProvider
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
      Db.save self 
      self
    end

    def exists?
      Db.exists? self
    end

    def ==(other)
      id == other.id && provider == other.provider
    end

    alias_method :eql?, :==

    def hash
      "#{@id}-#{provider}-#{@link}".hash
    end

    def <=>(other)
      title <=> other.title
    end

    MissingAttributeError = Class.new(RuntimeError)
  end
end
