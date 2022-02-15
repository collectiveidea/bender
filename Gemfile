source 'https://rubygems.org'

ruby "3.1.0"

gem 'rails', '~> 7.0.1'

gem 'pg'

# Assets
# group :assets do
#   gem 'sass-rails',   '~> 4.0.4'
#   gem 'uglifier',     '>= 1.3.0'
#   gem 'coffee-rails', '~> 4.0.0'
#
#   gem 'jquery-rails'
#   gem 'compass-rails'
#   gem 'd3js-rails'
#   gem 'rickshaw_rails'
#   gem 'momentjs-rails'
#   gem 'underscore-rails'
gem 'propshaft'
# end

gem 'font-awesome-rails'

gem 'actionpack-page_caching'
gem 'active_model_serializers'
gem 'bigdecimal'
gem 'kaminari'
gem 'rails-observers'
gem 'responders'

gem 'oj'


group :development do
  gem 'capistrano', '< 3.0'
  gem 'derailed'
  gem 'stackprof'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'nokogiri', require: false
  gem 'poltergeist'
  gem 'domino'
  gem 'factory_girl_rails'
  gem 'timecop'
  gem 'rubocop', require: false
  gem 'pry'
end

group :no_require do
  gem 'faye'
  gem 'thin'
  gem 'raindrops'
  gem 'god'
end
