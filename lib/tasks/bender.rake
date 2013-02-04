namespace :bender do
  desc "Read and report from each available temperature sensor"
  task :read_temps => :environment do
    Temp.sensors.each do |id, sensor|
      temp_sensor = TemperatureSensor.where(code: id).first
      temp_sensor ||= TemperatureSensor.create(name: id, code: id)
      begin
        temp_sensor.temperature_readings.create(reading: sensor.c)
      rescue Temp::ReadingFailed => e
        puts "Could not read temperature on #{id}\n#{e.message}"
      end
    end
  end
  
  desc "Monitor taps for pour activity"
  task :monitor_taps => :environment do
    BeerTap.monitor
  end
end
