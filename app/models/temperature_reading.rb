class TemperatureReading < ActiveRecord::Base
  belongs_to :temperature_sensor

  after_create :check_kegerator

  def temp_c=(val)
    super
    self.temp_f = (temp_c * 9 / 5) + 32
    val
  end

  def check_kegerator
    if kegerator = temperature_sensor.kegerator
      kegerator.check(self)
    end
    true
  end
end
