require 'logger'
require 'active_record'

log = '/tmp/database_recorder_test.log'
FileUtils.touch(log) unless File.exists?(log)

ActiveRecord::Base.logger = Logger.new(log)
ActiveRecord::Migration.verbose = false
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

class Entry < ActiveRecord::Base
end

ActiveRecord::Schema.define(:version => 1) do
  create_table 'entries', :force => true do |t|
    t.string :data
  end
end unless Entry.table_exists?

