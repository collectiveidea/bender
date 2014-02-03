RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.strategy = :transaction

    DatabaseCleaner.start
    example.run
    DatabaseCleaner.clean
  end

  config.around(:each, js: true) do |example|
    DatabaseCleaner.strategy = :truncation

    DatabaseCleaner.start
    example.run
    DatabaseCleaner.clean
  end
end
