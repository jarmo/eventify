module Event
  class Base
    attr_reader :provider, :title, :link, :date

    def initialize(event)
      @id = event[:id]
      @provider = event[:provider]
      @title = event[:title]
      @link = event[:link]
      @date = event[:date]
    end

    def guid
      "#@provider-#@id"
    end
  end
end
