class TemperatureReading < ActiveRecord::Base
  attr_accessible :reading, :temperature_sensor_id

  belongs_to :temperature_sensor

  def temp_f
    (reading * 9 / 5) + 32
  end
end
