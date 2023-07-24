require "simplecov"
require 'coveralls'

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start

require File.expand_path("../lib/eventify", __dir__)

require "tempfile"
require "webmock/rspec"
WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.color = true

  config.before do
    database_path = File.join(Dir.tmpdir, "eventify-test.sqlite3")
    stub_const "Eventify::Database::PATH", database_path

    sqlite = Eventify::Database.instance_variable_get(:@sqlite)
    sqlite.close if sqlite
    File.delete database_path if File.exist? database_path
    Eventify::Database.instance_variable_set(:@sqlite, nil)
  end
end

# monkey-patch StubSocket for backwards compatibility so that specs would pass
# on newer Rubies
class StubSocket
  def close
  end
end
