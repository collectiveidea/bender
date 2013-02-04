class TemperatureReading < ActiveRecord::Base
  attr_accessible :temp_c, :temperature_sensor_id

  belongs_to :temperature_sensor

  def temp_f
    (temp_c * 9 / 5) + 32
  end
end
