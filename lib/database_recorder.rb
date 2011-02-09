require 'database_recorder/active_record'

class DatabaseRecorder
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

  def capture
    if replay?
      results.shift
    else
      yield.tap { |result| results << result }
    end
  end

  def replay!
    self.load
    @replay = true
  end

  def replay?
    !!@replay
  end

  def save
    store.save(results)
  end

  def load
    @results = store.load
  end

  protected

    def results
      @results ||= []
    end

    def store
      @store ||= Store.new(Serializer.new)
    end
end
