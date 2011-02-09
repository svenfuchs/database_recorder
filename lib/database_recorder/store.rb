require 'tempfile'

class DatabaseRecorder
  class Store
    attr_reader :serializer

    def initialize(serializer)
      @serializer = serializer
    end

    def save(data)
      write(serializer.dump(data))
    end

    def load
      serializer.load(read)
    end

    protected

      def read
        File.read(path)
      rescue Errno::ENOENT
      end

      def write(data)
        File.open(path, 'w+') { |f| f.write(data) }
      end

      def path
        dir.join('db_session')
      end

      def dir
        @dir ||= Pathname.new(File.expand_path('.'))
      end
  end
end
