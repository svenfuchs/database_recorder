# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'database_recorder/version'

Gem::Specification.new do |s|
  s.name         = "database_recorder"
  s.version      = DatabaseRecorder::VERSION
  s.authors      = ["Sven Fuchs"]
  s.email        = "svenfuchs@artweb-design.de"
  s.homepage     = "http://github.com/svenfuchs/database_recorder"
  s.summary      = "[summary]"
  s.description  = "[description]"

  s.files        = Dir['{lib/**/*,[A-Z]*}']
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'

  s.add_dependency 'activerecord'
  s.add_development_dependency 'sqlite3-ruby'
  s.add_development_dependency 'database_cleaner', '0.5.2'
  s.add_development_dependency 'test_declarative'
end
