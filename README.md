# Eventify

Are you tired of missing some cool events because you just didn't know them
happening? Are you tired of not getting good sitting places because you heard
of some event too late?

If the answer was yes to either of these questions then Eventify can help you!

Eventify will notify you about upcoming events from different
providers/organizers.

## Installation

    $ gem install eventify

## Usage

Create configuration file:

    $ ruby -reventify -e "Eventify::Configuration.new.save"

Edit configuration settings by adding your e-mail into `subscribers` list:
    
    $ vi ~/.eventify/config.yaml

Run it from command line and add it into `cron`:

    $ ruby -reventify -e "Eventify.new.process_new_events"

## Supported Providers

The following providers are currently supported:

* [FBI](http://fbi.ee)
* [Piletilevi](http://www.piletilevi.ee/)
* [Ticketpro](http://www.ticketpro.ee/)

## Adding New Providers

Adding new providers is easy. You just need to create a class with one method
satisfying the contract:

```ruby
require "eventify"

class MyCustomProvider < Eventify::Provider::Base
  def self.fetch
    # fetch some atom feed
    rss = SimpleRSS.parse open("http://example.org/rss.xml")
    rss.entries.map { |entry| new id: entry.guid, title: entry.title, link: entry.link, date: entry.pubDate }
  end
end

# use that provider with Eventify
eventify = Eventify.new
eventify.providers = [MyCustomProvider]
eventify.process_new_events
```

## License

See [LICENSE](https://github.com/jarmo/eventify/blob/master/LICENSE).
