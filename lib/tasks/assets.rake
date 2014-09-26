namespace :assets do
  # Override this task to change the loaded dependencies
  desc "Load asset compile environment"
  task :environment do
    # Load gems in assets group of Gemfile
    Bundler.require(:assets) if defined?(Bundler)
    # Load full Rails environment by default
    Rake::Task['environment'].invoke
  end
end
