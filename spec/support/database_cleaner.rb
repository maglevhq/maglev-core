# frozen_string_literal: true

begin
  require 'database_cleaner/active_record'

  RSpec.configure do |config|
    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
    end

    config.around(:each) do |example|
      DatabaseCleaner.cleaning do
        example.run
      end
    end
  end
rescue LoadError
  # DatabaseCleaner is not available
end
