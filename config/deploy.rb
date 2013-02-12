require "bundler/capistrano"

load "deploy/assets"

# Application settings
set :user,          "pi"
set :use_sudo,      false
set :rails_env,     "production"
set :application,   "bender"

# Server Settings
hostname = "example.com"
role :app, hostname
role :web, hostname
role :db,  hostname, :primary => true


# SCM Settings
set :scm,        :git
set :repository, "git://github.com/collectiveidea/bender.git"
set :deploy_via, :remote_cache

# Deployment Settings
set :deploy_to,    "/app/bender"

set :bundle_flags,    "--deployment --quiet --binstubs=.bin"

after "deploy:finalize_update", "deploy:configs"

namespace :deploy do
  task :stop, :roles => :app do
    # NOOP. Can't stop this train.
  end

  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :configs do
    # Symlink specific files in shared/config to the releases config directory
    %w(
      database.yml
    ).each do |config|
      run "ln -nfsT #{shared_path}/config/#{config} #{release_path}/config/#{config}"
    end
  end
end

# Clean up old deploys after each deploy (leaves 5)
after "deploy", "deploy:cleanup"
