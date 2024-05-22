source "https://rubygems.org"

ruby "3.3.1"

gem "rails", "~> 7.1.3"

gem "pg"

# Assets
gem "cssbundling-rails"
gem "importmap-rails"
gem "propshaft"

gem "actionpack-page_caching"
gem "active_model_serializers"
gem "bigdecimal"
gem "dotenv-rails"
gem "honeybadger"
gem "pagy"
gem "puma"
gem "rails-observers"

gem "oj"

group :development do
  gem "derailed"
  gem "stackprof"
end

group :test, :development do
  gem "domino"
  gem "factory_bot_rails"
  gem "pry"
  gem "rspec-rails"
  gem "selenium-webdriver"
  gem "standard"
  gem "standard-performance"
  gem "standard-rails"
end

group :no_require do
  gem "faye"
  # This gem is normally pulled in via faye, but cuurrent version
  # breaks with --enable=frozen-string-literal so remove when version > 0.7.5
  # https://github.com/faye/websocket-driver-ruby/pull/85
  gem "websocket-driver", github: "faye/websocket-driver-ruby"
end
