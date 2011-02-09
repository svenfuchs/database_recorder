require 'rubygems'
require 'test/unit'
require 'ruby-debug'
require 'logger'
require 'pp'
require 'bundler/setup'

require 'test_declarative'
require 'database_cleaner'
require 'database_recorder'
require 'test_connection'

DatabaseCleaner.strategy = :truncation

class Test::Unit::TestCase
  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end
