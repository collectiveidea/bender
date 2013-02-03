class Temp
  DEVICE_DIR = '/sys/bus/w1/devices/'
  def self.discover
    @sensors = Dir["#{DEVICE_DIR}28-*/w1_slave"].inject({}) do |hsh, path|
      sensor = Sensor.new(path)
      hsh[sensor.id] = sensor
      hsh
    end
  end

  def self.[](val)
    (@sensors || discover)[val]
  end

  def self.[]=(name, val)
    (@sensors || discover)[name] = val
  end

  def self.sensors
    @sensors || discover
  end

  class Sensor
    TEMP_REGEX = /^t=([0-9]+)$/
    attr_reader :name, :id

    def initialize(path)
      @path = path
      @id   = %r{/28-([^/]+)}.match(path)[1]
      @value = -100.0
    end

    def name=(val)
      Temp[@name] = nil if @name

      @name = val
      Temp[@name] = self
      val
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
      output = File.read(@path)
      parts = output.split
      if parts.include?('YES')
        if parts.detect {|p| TEMP_REGEX =~ p }
          @value = $1.to_i / 1000.0
        else
          puts "No temp found #{Time.now} #{@id}\n#{output}\n\n"
        end
      else
        puts "CRC Failed #{Time.now} #{@id}"
      end
    end
  end
end
