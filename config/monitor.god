working_dir = File.expand_path("../..", __FILE__)
working_dir.sub!(%r{releases/[0-9]+}, 'current')

God.pid_file_directory = File.join(working_dir, "tmp/pids")

God.watch do |w|
  w.name  = "rails_server"
  w.env   = {"RAILS_ENV" => "production"}
  w.dir   = working_dir
  w.group = "bender"
  w.keepalive

  w.start = "bundle exec rails server"
end

God.watch do |w|
  w.name  = "temp_monitor"
  w.env   = {"RAILS_ENV" => "production", "NO_SPROCKETS" => "true"}
  w.log   = File.join(working_dir, "log/temp_monitor.log")
  w.dir   = working_dir
  w.group = "bender"
  w.keepalive

  w.start = "bundle exec rake bender:monitor_temps"
end

God.watch do |w|
  w.name  = "tap_monitor"
  w.env   = {"RAILS_ENV" => "production", "NO_SPROCKETS" => "true"}
  w.log   = File.join(working_dir, "log/tap_monitor.log")
  w.dir   = working_dir
  w.group = "bender"
  w.keepalive

  w.start = "bundle exec rake bender:monitor_taps"
end

God.watch do |w|
  w.name     = "faye"
  w.pid_file = File.join(working_dir, 'tmp/pids/faye.pid')
  w.dir      = working_dir
  w.group = "bender"
  w.keepalive

  w.start = "bundle exec rackup faye.ru -s thin -E production -D --pid #{w.pid_file}"
end
