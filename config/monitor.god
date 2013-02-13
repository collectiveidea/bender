working_dir = File.expand_path("../..", __FILE__)

God.pid_file_directory = File.expand_path("tmp/pids", working_dir)

God.watch do |w|
  w.name  = "temp_monitor"
  w.env   = {"RAILS_ENV" => "production"}
  w.log   = File.expand_path("log/temp_monitor.log", working_dir)
  w.dir   = working_dir
  w.keepalive

  w.start = "bundle exec rake bender:monitor_temps"
end

God.watch do |w|
  w.name  = "tap_monitor"
  w.env   = {"RAILS_ENV" => "production"}
  w.log   = File.expand_path("log/tap_monitor.log", working_dir)
  w.dir   = working_dir
  w.keepalive

  w.start = "bundle exec rake bender:monitor_taps"
end

God.watch do |w|
  w.name     = "faye"
  w.pid_file = File.expand_path('faye.pid', God.pid_file_directory)
  w.dir      = working_dir
  w.keepalive

  w.start = "bundle exec rackup faye.ru -s thin -E production -D --pid #{w.pid_file}"
end
