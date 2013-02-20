class TemperatureSensor < ActiveRecord::Base
  attr_accessible :code, :name

  has_many :temperature_readings
  has_one :latest_reading, class_name: 'TemperatureReading', order: 'created_at DESC'

  def self.for_select
    all.map {|tap| [tap.name, tap.id] }
  end

  def sensor
    @sensor ||= Temp::Sensor.from_id(code)
  end

  def temp_data(start_time = 24.hours.ago, end_time = Time.now)
    temperature_readings.where(['created_at >= ? AND created_at < ?', start_time, end_time]).order('created_at').select([:temp_f, :created_at])
  end
end
