require File.expand_path("../lib/eventify", __dir__)

require "webmock/rspec"
WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.color = true

  config.before do
    require "db"

    database_path = File.expand_path("../db/eventify-test.db", __dir__)
    stub_const "Db::DATABASE_PATH", database_path
    test_database = database_path

    sqlite = Db.instance_variable_get(:@sqlite)
    sqlite.close if sqlite
    File.delete test_database if File.exists? test_database
    Db.instance_variable_set(:@sqlite, nil)
  end
end
