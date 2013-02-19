namespace :bender do
  desc "Acts as a thermostat for the kegerator"
  task :monitor_kegerator => :environment do
    Kegerator.monitor
  end

  desc "Read and report from each available temperature sensor"
  task :monitor_temps => :environment do
    loop do
      Temp.discover.each do |id, sensor|
        temp_sensor = TemperatureSensor.where(code: id).first
        temp_sensor ||= TemperatureSensor.create(name: id, code: id)
        begin
          temp_sensor.temperature_readings.create(temp_c: sensor.c)
        rescue Temp::ReadingFailed => e
          puts "Could not read temperature on #{id}\n#{e.message}"
        end
      end

      sleep(60 - Time.now.sec)
    end
  end

  desc "Monitor taps for pour activity"
  task :monitor_taps => :environment do
    TapMonitor.monitor_taps
  end
end
