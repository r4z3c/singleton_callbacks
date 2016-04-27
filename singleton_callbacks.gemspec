$:.push File.expand_path('../lib', __FILE__)

require 'singleton_callbacks/version'

Gem::Specification.new do |s|
  s.name        = 'singleton_callbacks'
  s.version     = SingletonCallbacks::VERSION
  s.authors     = ['r4z3c']
  s.email       = ['r4z3c.43@gmail.com']
  s.homepage    = 'https://github.com/r4z3c/singleton_callbacks.git'
  s.summary     = 'Callbacks support for Ruby singleton classes'
  s.description = 'Provides callbacks support for Ruby singleton classes'
  s.licenses    = %w(MIT)

  s.files = `git ls-files`.split("\n")
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  s.require_paths = %w(lib)

  s.add_dependency 'bundler', '~>1'
  s.add_dependency 'activesupport', '~>4'

  s.add_development_dependency 'sqlite3', '~>1'
  s.add_development_dependency 'rspec', '~>3'
  s.add_development_dependency 'simplecov', '~>0'
  s.add_development_dependency 'model-builder'
  s.add_development_dependency 'rake'
end
