# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = %q{is_taggable}
  s.version     = "0.1.2"
  s.platform    = Gem::Platform::RUBY

  s.required_ruby_version = ">= 1.8.7"
  s.required_rubygems_version = ">= 1.3.5"

  s.authors     = ["Daniel Haran", "James Golick", "GiraffeSoft Inc."]
  s.email       = %q{chebuctonian@mgmail.com}
  s.summary     = %q{tagging that doesn't want to be on steroids. it's skinny and happy to stay that way.}

  s.files       = `git ls-files`.split("\n")
  s.homepage    = %q{http://github.com/giraffesoft/is_taggable}
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'activerecord', '~> 3.0'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'expectations'
  s.add_development_dependency 'sqlite3'
  #s.add_development_dependency 'activerecord-sqlite3-adapter'
end
