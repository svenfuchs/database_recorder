class DatabaseRecorder
  class Serializer
    def load(data)
      Marshal.load(data || {})
    rescue TypeError
    end

    def dump(data)
      Marshal.dump(data)
    end
  end
end
