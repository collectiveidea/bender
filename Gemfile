source 'https://rubygems.org'

gem 'rails', '~> 4.1.8'

gem 'pg'

# Assets
group :assets do
  gem 'sass-rails',   '~> 4.0.4'
  gem 'uglifier',     '>= 1.3.0'
  gem 'coffee-rails', '~> 4.0.0'

  gem 'jquery-rails'
  gem 'compass-rails'
  gem 'd3js-rails'
  gem 'rickshaw_rails'
  gem 'momentjs-rails'
end

gem 'actionpack-page_caching'
gem 'active_model_serializers'
gem 'kaminari'
gem 'rails-observers'

gem 'oj'

# Deployment
gem 'capistrano', '< 3.0', group: :development

group :test, :development do
  gem 'rspec-rails', '~> 2.0'
  gem 'capybara',    '~> 2.0'
  gem 'nokogiri', require: false
  gem 'poltergeist', '~> 1.1'
  gem 'domino'
  gem 'database_cleaner', '< 1.4.0'
  gem 'factory_girl_rails'
  gem 'timecop'
  gem 'rubocop', require: false
end

group :no_require do
  gem 'faye'
  gem 'thin'
  gem 'raindrops'
  gem 'god'
end
