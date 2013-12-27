module Event
  class Base
    class << self
      def fetch
        raise NotImplementedError
      end
    end

    attr_reader :id, :title, :link, :date

    def initialize(event)
      @id = event[:id]
      @title = event[:title]
      @link = event[:link]
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

  end
end
