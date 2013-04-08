class Kegerator < ActiveRecord::Base
  attr_accessible :max_temp, :min_temp, :name, :temperature_sensor_id, :control_pin

  belongs_to :temperature_sensor
  has_many :beer_taps

  def check(reading)
    return if control_pin.blank? || min_temp.blank? || max_temp.blank?

    report_dms(reading)

    pin = GPIO::Pin.new(:pin => control_pin, :direction => :out)
    if pin.on?
      if reading.temp_f < min_temp
        self.last_shutdown = Time.now
        self.save
        pin.off
      elsif alarm_temp && reading.temp_f > alarm_temp
        send_alarm_message(reading)
      end
    elsif pin.off? && reading.temp_f > max_temp && (last_shutdown.nil? || last_shutdown < 5.minutes.ago)
      pin.on
    end
  end

  # This should send a message on the first alarm reading and every 30 minutes after that
  def send_alarm_message(reading)
    last_good = temperature_sensor.temperature_readings.where(['temp_f < ?', alarm_temp]).order('created_at DESC').first.try(:created_at)
    return if last_good.nil? || (((Time.now - last_good) / 60).round % 30) != 1

    Hubot.send_message("ALERT: The kegerator temperature is at %0.1f" % [reading.temp_f])
  end

  def report_dms(reading)
    # don't report to DMS if we are above the alarm temp
    return if Setting.dms_url.blank? || reading.temp_f > alarm_temp

    uri = URI(Setting.dms_url)
    begin
      Net::HTTP.get(uri)
    rescue => e
      puts "Failed to connect to DMS with: #{e.inspect} (#{Time.now})"
    end
  end
end
