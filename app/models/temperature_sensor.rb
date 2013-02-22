class TemperatureSensor < ActiveRecord::Base
  attr_accessible :code, :name

  has_many :temperature_readings
  has_one :latest_reading, class_name: 'TemperatureReading', order: 'created_at DESC'

  def self.for_select
    all.map {|tap| [tap.name, tap.id] }
  end

  def self.monitor
    loop do
      Temp.discover.each do |id, sensor|
        temp_sensor = where(code: id).first || create(name: id, code: id)
        begin
          temp_sensor.temperature_readings.create(temp_c: sensor.c)
        rescue Temp::ReadingFailed => e
          puts "Could not read temperature on #{id}\n#{e.message}"
        end
      end

      sleep(60 - Time.now.sec)
    end
  end

  def sensor
    @sensor ||= Temp::Sensor.from_id(code)
  end

  def temp_data(start_time = 24.hours.ago, end_time = Time.now)
    temperature_readings.where(['created_at >= ? AND created_at < ?', start_time, end_time]).order('created_at').select([:temp_f, :created_at])
  end
end
