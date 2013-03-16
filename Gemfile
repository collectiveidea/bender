source 'https://rubygems.org'

gem 'rails', '3.2.12'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'

  gem 'turbo-sprockets-rails3'
end

gem 'jquery-rails'
gem 'd3js-rails'

gem 'faye', require: false
gem 'thin', require: false

gem 'raindrops', require: false

gem 'oj'

# Deployment
gem "capistrano", group: :development

gem 'god', require: false

group :test, :development do
  gem 'rspec-rails', '~> 2.0'
  gem 'capybara', '~> 2.0'
  gem 'poltergeist', '~> 1.1'
  gem 'domino', github: 'ersatzryan/domino', ref: 'callbacks'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'debugger'
end


gem 'active_model_serializers'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# To use debugger
# gem 'debugger'
