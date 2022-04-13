namespace :bender do
  desc "Read and report from each available temperature sensor"
  task monitor_temps: :environment do
    TemperatureSensor.monitor
  end

  desc "Monitor taps for pour activity"
  task monitor_taps: :environment do
    TapMonitor.monitor_taps
  end
end
