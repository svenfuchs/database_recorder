require 'active_record'
require 'active_support/core_ext/module/delegation'

class DatabaseRecorder
  class << self
    def start!
      class << ActiveRecord::Base.connection
        def execute(sql, name = nil)
          DatabaseRecorder.instance.capture(sql) { super }
        end
      end

      class << ActiveRecord::Base.connection.instance_variable_get(:@connection)
        def changes
          DatabaseRecorder.instance.capture("(SELECT) #{self.class.name}.changes") { super }
        end

        def last_insert_row_id
          DatabaseRecorder.instance.capture("(SELECT) #{self.class.name}.last_insert_row_id") { super }
        end
      end
    end

    def stop!
      instance.save
      @instance = nil

      class << ActiveRecord::Base.connection
        remove_method(:execute)
      end

      class << ActiveRecord::Base.connection.instance_variable_get(:@connection)
        remove_method(:last_insert_row_id)
      end
    end
  end
end
