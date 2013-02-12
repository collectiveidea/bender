class Temp
  DEVICE_DIR = '/sys/bus/w1/devices/'

  def self.discover
    Dir["#{DEVICE_DIR}28-*/w1_slave"].inject({}) do |hsh, path|
      sensor = Sensor.new(path)
      hsh[sensor.id] = sensor
      hsh
    end
  end

  def self.[](val)
    (@sensors ||= discover)[val]
  end

  def self.[]=(name, val)
    (@sensors ||= discover)[name] = val
  end

  def self.sensors
    @sensors ||= discover
  end

  class ReadingFailed < StandardError; end

  class Sensor
    TEMP_REGEX = /^t=(\-?[0-9]+)$/
    ID_REGEX = %r{/28-([^/]+)}
    attr_reader :id

    def initialize(path)
      @path  = path
      @id    = ID_REGEX.match(path)[1]
      @value = -100.0
    end

    def c
      read
      @value
    end

    def f
      read
      (@value * 9 / 5) + 32
    end

    def read
      @tries = 0
      begin
        output = File.read(@path)
        parts = output.split
        if parts.include?('YES')
          if parts.detect {|p| TEMP_REGEX =~ p }
            @value = $1.to_i / 1000.0
          else
            raise ReadingFailed, "No temp found #{Time.now} #{@id}\n#{output}\n\n"
          end
        else
          raise ReadingFailed, "CRC Failed #{Time.now} #{@id}"
        end
      rescue ReadingFailed => error
        @tries += 1

        if @tries <= 5 && /^CRC/ =~ error.message
          sleep 1
          retry
        else
          raise
        end
      end
    end
  end
end
