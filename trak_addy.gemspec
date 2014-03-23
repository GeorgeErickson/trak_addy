# -*- encoding: utf-8 -*-

require File.expand_path('../lib/trak_addy/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "trak_addy"
  gem.version       = TrakAddy::VERSION
  gem.summary       = %q{TODO: Summary}
  gem.description   = %q{TODO: Description}
  gem.license       = "MIT"
  gem.authors       = ["George Erickson"]
  gem.email         = "george55@mit.edu"
  gem.homepage      = "https://rubygems.org/gems/trak_addy"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'faraday'
  gem.add_dependency 'bonfig'
  gem.add_dependency 'activemodel'
  gem.add_dependency 'activesupport'
  gem.add_dependency 'activeresource'
  gem.add_development_dependency 'bundler', '~> 1.0'
  gem.add_development_dependency 'rake', '~> 0.8'
  gem.add_development_dependency 'rspec', '~> 2.4'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency 'yard', '~> 0.8'
end
