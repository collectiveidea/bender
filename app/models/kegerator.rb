class Kegerator < ActiveRecord::Base
  belongs_to :temperature_sensor
  has_many :beer_taps

  def check(reading)
    return if control_pin.blank? || min_temp.blank? || max_temp.blank?

    if pin.on? && reading.temp_f < min_temp
      self.last_shutdown = Time.now
      save
      pin.off
    elsif pin.off? && reading.temp_f > max_temp && (last_shutdown.nil? || last_shutdown < 5.minutes.ago)
      pin.on
    end

    report_dms(reading)
    check_alarms(reading)
  end

  def check_alarms(reading)
    send_alarm_message(reading) if alarm_temp && reading.temp_f > alarm_temp
    send_all_clear_message(reading) if alarm_temp && reading.temp_f > max_temp && reading.temp_f < alarm_temp
  end

  def cooling?
    return nil unless temperature_sensor
    readings = temperature_sensor.temperature_readings

    most_recent_temp = readings.where(['created_at > ?', 5.minutes.ago]).order('created_at DESC').first.try(:temp_f)
    return nil unless most_recent_temp

    readings.where(['created_at > ? AND temp_f > ?', 30.minutes.ago, most_recent_temp]).exists?
  end

  # This should send a message on the first alarm reading and every 30 minutes after that
  def send_alarm_message(reading)
    last_good = temperature_sensor.temperature_readings.where(['temp_f < ?', alarm_temp]).order('created_at DESC').first.try(:created_at)
    return if last_good.nil? || (((Time.now - last_good) / 60).round % 30) != 1 || cooling?

    # Try to reset the GFCI
    pin.off

    Hubot.send_message('ALERT: The kegerator temperature is at %0.1f' % [reading.temp_f])
  end

  def send_all_clear_message(reading)
    if temperature_sensor.temperature_readings.where(['temp_f < ? AND created_at > ?', alarm_temp, 10.minutes.ago]).count == 1
      Hubot.send_message('All Clear: The kegerator is now below the alarm temperature')
    end
  end

  def report_dms(reading)
    # don't report to DMS if we are above the alarm temp
    return if Setting.dms_url.blank? || (reading.temp_f > alarm_temp && !cooling?)

    uri = URI(Setting.dms_url)
    begin
      Net::HTTP.start(uri.host, uri.port, use_ssl: (uri.scheme == 'https')) do |http|
        http.request(Net::HTTP::Get.new(uri.request_uri))
      end
    rescue => e
      puts "Failed to connect to DMS with: #{e.inspect} (#{Time.now})"
    end
  end

  protected

  def pin
    @pin ||= GPIO::Pin.new(pin: control_pin, direction: :out)
  end
end
