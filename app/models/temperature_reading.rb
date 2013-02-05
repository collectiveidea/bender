class TemperatureReading < ActiveRecord::Base
  attr_accessible :temp_c, :temperature_sensor_id

  belongs_to :temperature_sensor

  def temp_c=(val)
    super
    self.temp_f = (temp_c * 9 / 5) + 32
    val
  end
end
