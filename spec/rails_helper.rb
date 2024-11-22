# frozen_string_literal: true

require 'simplecov'
SimpleCov.start 'rails'

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
ENGINE_ROOT = File.join(File.dirname(__FILE__), '../')
# require File.expand_path('../config/environment', __dir__)

require 'rails/version'
if Rails::VERSION::MAJOR < 8
  require_relative './legacy_dummy/config/environment'
else
  require_relative './dummy/config/environment'
end

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

require 'factory_bot_rails'

FactoryBot.definition_file_paths << File.join(File.dirname(__FILE__), 'factories')
FactoryBot.find_definitions

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# puts Rails.root.join('spec', 'support', '**', '*.rb').inspect
Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migrator.migrations_paths = File.join(ENGINE_ROOT, 'spec/dummy/db/migrate')
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  if Rails::VERSION::MAJOR >= 8 || (Rails::VERSION::MAJOR >= 7 && Rails::VERSION::MINOR > 0)
    config.fixture_paths = [File.join(File.dirname(__FILE__), 'fixtures')]
  else
    config.fixture_path = File.join(File.dirname(__FILE__), 'fixtures')
  end

  config.include ActionDispatch::TestProcess::FixtureFile
  config.include FactoryBot::Syntax::Methods
  config.include Maglev::SpecHelpers::ApiAuthentication, type: :request

  config.before do
    Maglev.configure do |c|
      c.services = {}
      c.admin_username = nil
      c.admin_password = nil
    end
    Maglev::I18n.available_locales = [:en]
    Maglev::I18n.current_locale = :en
    ::I18n.locale = :en
  end

  config.after(:suite) do
    FileUtils.rm_rf(Dir[Rails.root.join('spec/dummy/tmp/storage')])
  end

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end
