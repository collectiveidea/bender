class Kegerator < ActiveRecord::Base
  attr_accessible :max_temp, :min_temp, :name, :temperature_sensor_id, :control_pin

  belongs_to :temperature_sensor
  has_many :beer_taps

  def self.monitor
    loop do
      all.each {|kegerator| kegerator.check }
      sleep(60)
    end
  end

  def check
    return if control_pin.blank? || min_temp.blank? || max_temp.blank?

    pin = GPIO::Pin.new(:pin => control_pin, :direction => :out)
    current_temp = temperature_sensor.sensor.f
    if pin.on? && current_temp < min_temp
      self.last_shutdown = Time.now
      self.save
      pin.off
    elsif pin.off? && current_temp > max_temp && (last_shutdown.nil? || last_shutdown < 5.minutes.ago)
      pin.on
    end
  end
end
