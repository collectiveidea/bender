God.pid_file_directory = File.expand_path("../../tmp/pids", __FILE__)

God.watch do |w|
  w.name = "temp_monitor"

  w.start = "rake bender:monitor_temps"

  w.env   = {"RAILS_ENV" => "production"}
  w.log   = File.expand_path("../../log/temp_monitor.log", __FILE__)
  w.dir   = File.expand_path("../..", __FILE__)
end

God.watch do |w|
  w.name = "tap_monitor"

  w.start = "rake bender:monitor_taps"

  w.env   = {"RAILS_ENV" => "production"}
  w.log   = File.expand_path("../../log/tap_monitor.log", __FILE__)
  w.dir   = File.expand_path("../..", __FILE__)
end
