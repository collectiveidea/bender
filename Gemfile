source 'https://rubygems.org'

ruby "3.1.1"

gem 'rails', '~> 7.0.1'

gem 'pg'

# Assets
gem 'cssbundling-rails'
gem 'importmap-rails'
gem 'propshaft'

gem 'actionpack-page_caching'
gem 'active_model_serializers'
gem 'bigdecimal'
gem 'kaminari'
gem 'rails-observers'

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
  gem 'factory_bot_rails'
  gem 'rubocop', require: false
  gem 'pry'
end

group :no_require do
  gem 'faye'
  # This gem is normally pulled in via faye, but cuurrent version
  # breaks with --enable=frozen-string-literal so remove when version > 0.7.5
  # https://github.com/faye/websocket-driver-ruby/pull/85
  gem "websocket-driver", github: "faye/websocket-driver-ruby"
  gem 'thin'
  gem 'raindrops'
  gem 'god'
end
