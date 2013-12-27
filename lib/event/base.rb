module Event
  class Base
    attr_reader :title, :link, :date

    def initialize(event)
      @id = event[:id]
      @title = event[:title]
      @link = event[:link]
      @date = event[:date]
    end

    def guid
      "#{provider}-#{@id}"
    end

    def provider
      @provider ||= self.class.name.downcase.split("::").last
    end

  end
end
