# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'entity_query'
  s.version = '0.4.1'
  s.summary = 'A general interface for querying entity streams'
  s.description = 'Provides a standard interface to query a stream given a conditional block to fetch entities at a particular version'

  s.authors = ['brad@platformgroup.ca']
  s.homepage = 'https://imirwin.com'
  s.licenses = ['Nonstandard']

  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.4'

  s.add_runtime_dependency 'eventide-postgres', '~> 1.0'

  s.add_development_dependency 'test_bench', '~> 1.3'
  s.add_development_dependency 'byebug', '~> 10.0'
end
