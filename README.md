# Eventify
[![Gem Version](https://badge.fury.io/rb/eventify.png)](http://badge.fury.io/rb/eventify)
[![Build Status](https://api.travis-ci.org/jarmo/eventify.png)](http://travis-ci.org/jarmo/eventify)
[![Coverage](https://coveralls.io/repos/jarmo/eventify/badge.png?branch=master)](https://coveralls.io/r/jarmo/eventify)
[![Dependency Status](https://gemnasium.com/jarmo/eventify.png)](https://gemnasium.com/jarmo/eventify)
[![Code Climate](https://codeclimate.com/github/jarmo/eventify.png)](https://codeclimate.com/github/jarmo/eventify)

Are you tired of missing some cool concerts/events because you just didn't know them
happening? Are you tired of not getting good sitting places because you heard
of some event too late?

If the answer was yes to either of these questions then Eventify can help you!

Eventify will notify you about upcoming events from different
providers/organizers in an aggregate way.

## Installation

    $ gem install eventify

## Usage

* Create configuration file with your e-mail address:

    `$ ruby -reventify -e "Eventify::Configuration.new(subscribers: ['foo@bar.com']).save"`

* Run it from command line and add it into `cron`:

    `$ ruby -reventify -e "Eventify.new.process_new_events"`

* Check your e-mail for information about upcoming events.

* Edit configuration settings if defaults won't work for you:
    
     `$ vi ~/.eventify/config.yaml`

## Supported Providers

The following providers are currently supported:

* [Livenation](https://livenation.ee)
* [Piletilevi](http://www.piletilevi.ee/)
* [Solaris Kino](http://solariskino.ee/)

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
