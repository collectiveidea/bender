class TemperatureReading < ApplicationRecord
  belongs_to :temperature_sensor

  after_create :check_kegerator
  after_create :notify_faye

  def temp_c=(val)
    self.temp_f = (val * 9 / 5) + 32
    self[:temp_c] = val
  end

  def check_kegerator
    temperature_sensor&.kegerator&.check(self)
    true
  end

  def notify_faye
    FayeNotifier.send_message("/temperature/#{temperature_sensor_id}", [temp_f, created_at.to_f])
    true
  end
end
