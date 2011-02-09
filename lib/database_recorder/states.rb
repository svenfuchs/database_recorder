class DatabaseRecorder
  class States < Array
    class State < Hash
      def initialize
        super({})
      end
    end

    def initialize
      self << State.new
    end

    def empty?
      first.empty?
    end

    def create!
      self << State.new
      next!
    end

    def reset!
      @ix = 0
    end

    def current
      self[ix]
    end

    def next!
      @ix = ix + 1
    end

    def ix
      @ix ||= 0
    end
  end
end
