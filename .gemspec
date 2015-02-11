# encoding: utf-8

$:.push File.expand_path('../lib/', __FILE__)
require 'grache/version'

Gem::Specification.new do |s|
  s.name = 'grache'
  s.version = Grache::VERSION
  s.licenses = ['MIT']

  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.authors = [
    'Tomas Korcak'
  ]

  s.summary = 'Great Ruby Cache for gems'
  s.description = 'Great Ruby Cache for ruby gems'
  s.email = 'korczis@gmail.com'
  s.executables = ['grache']
  s.extra_rdoc_files = %w(LICENSE README.md)

  s.files = `git ls-files`.split($/)
  s.homepage = 'http://github.com/korczis/grache'
  s.require_paths = ['lib']

  s.add_development_dependency 'coveralls', '~> 0.7', '>= 0.7.8'
  s.add_development_dependency 'rake', '~> 10.3', '>= 10.3.1'
  s.add_development_dependency 'rake-notes', '~> 0.2', '>= 0.2.0'
  s.add_development_dependency 'redcarpet', '~> 3.1', '>= 3.1.1' if RUBY_PLATFORM != 'java'
  s.add_development_dependency 'rspec', '~> 3.1', '>= 3.1.7'
  s.add_development_dependency 'rubocop', '~> 0.27', '>= 0.27.0'
  s.add_development_dependency 'simplecov', '~> 0.9', '>= 0.9.1'
  s.add_development_dependency 'yard', '~> 0.8.7.3'
  s.add_development_dependency 'ZenTest', '~> 4.10', '>= 4.11.0'

  s.add_development_dependency 'debase', '~> 0' if !ENV['TRAVIS_BUILD'] && RUBY_VERSION >= '2.0.0'
  s.add_development_dependency 'ruby-debug-ide', '~> 0' if !ENV['TRAVIS_BUILD'] && RUBY_VERSION >= '2.0.0'

  # s.add_dependency 'activesupport', '~> 4.1', '>= 4.1.0'
  s.add_dependency 'aws-sdk', '~> 1.45'
  s.add_dependency 'bundler', '~> 1.7.8'
  s.add_dependency 'docile', '~> 1.1', '>= 1.1.5'
  s.add_dependency 'erubis', '~> 2.7', '>= 2.7.0'
  s.add_dependency 'gli', '~> 2.12', '>= 2.12.2'
  s.add_dependency 'highline', '~> 1.6', '>= 1.6.21'
  s.add_dependency 'i18n', '~> 0.7.0', '>= 0.7.0'
  s.add_dependency 'json_pure', '~> 1.8.0'
  s.add_dependency 'multi_json', '~> 1.10', '>= 1.10.0'
  s.add_dependency 'parseconfig', '~> 1.0', '>= 1.0.4'
  s.add_dependency 'pmap', '~> 1.0', '>= 1.0.1'
  s.add_dependency 'pry', '~> 0.9.12.6' # '~> 0.10', '>= 0.10.1'
  s.add_dependency 'rubyzip', '~> 1.1', '>= 1.1.0'
  s.add_dependency 'terminal-table', '~> 1.4', '>= 1.4.5'
end
