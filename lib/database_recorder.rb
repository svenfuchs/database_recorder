require 'database_recorder/active_record'

class DatabaseRecorder
  autoload :States, 'database_recorder/states'
  autoload :Serializer, 'database_recorder/serializer'
  autoload :Store, 'database_recorder/store'

  class << self
    delegate :capture, :load, :save, :replay!, :to => :instance

    def record_or_replay!(condition)
      start!
      if condition
        replay!
      else
        at_exit { save }
      end
    end

    def instance
      @instance ||= DatabaseRecorder.new
    end
  end

  def capture(sql)
    replay? ? replaying(sql) { yield } : recording(sql) { yield }
  end

  def replay!
    self.load
    states.reset!
    @replay = true
  end

  def replay?
    !!@replay
  end

  def save
    store.save(states)
  end

  def load
    @states = store.load
  end

  protected

    def states
      @states ||= States.new
    end

    def store
      @store ||= Store.new(Serializer.new)
    end

    def recording(sql)
      states.create! # unless idempotent?(sql)
      yield.tap { |result| states.current[sql] = result }
    end

    def replaying(sql)
      states.next! # unless idempotent?(sql)
      states.current[sql]
    end

    def idempotent?(sql)
      sql !~ /^\s*(?:INSERT|UPDATE|DELETE)/
    end
end
