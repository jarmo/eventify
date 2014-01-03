# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eventify/version'

Gem::Specification.new do |spec|
  spec.name          = "eventify"
  spec.version       = Eventify::VERSION
  spec.authors       = ["Jarmo Pertman"]
  spec.email         = ["jarmo.p@gmail.com"]
  spec.description   = %q{Get notifications about upcoming events from different providers/organizers.}
  spec.summary       = %q{Get notifications about upcoming events from different providers/organizers.}
  spec.homepage      = "https://github.com/jarmo/eventify"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "simple-rss"
  spec.add_dependency "nokogiri"
  spec.add_dependency "sqlite3"
  spec.add_dependency "mail"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "yard"
end
