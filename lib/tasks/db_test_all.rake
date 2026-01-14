# frozen_string_literal: true

# Database Migration Testing Automation
#
# This Rake task automates the process of testing migrations against multiple
# databases and Rails versions, generating schema files for each combination.
#
# Usage:
#   # Test all databases with all Rails versions
#   bundle exec rake db:test_all
#
#   # Test all databases with current Gemfile
#   bundle exec rake db:test:all
#
#   # Test specific database with current Gemfile
#   bundle exec rake db:test:pg
#   bundle exec rake db:test:sqlite
#   bundle exec rake db:test:mysql
#   bundle exec rake db:test:mariadb
#
#   # Test with specific Rails version
#   BUNDLE_GEMFILE=Gemfile.rails_7_2 bundle exec rake db:test:all
#
# Environment variables:
#   CONTINUE_ON_ERROR=1  - Continue testing other databases even if one fails
#   DEBUG=1              - Show detailed error backtraces
#
# The task will:
#   1. Backup schema.rb (PG schema) before switching databases
#   2. Restore appropriate schema file for each database
#   3. Run migrations
#   4. Generate new schema files
#   5. Save schemas with appropriate prefixes (schema.sqlite.rb, etc.)
#   6. Run tests
#   7. Restore schema.rb to PG version (for Git)

require 'fileutils'
require 'open3'

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Naming/VariableNumber, Metrics/CyclomaticComplexity

DATABASES = {
  pg: {
    env: {
      MAGLEV_APP_DATABASE_USERNAME: ENV.fetch('MAGLEV_APP_DATABASE_USERNAME', ''),
      MAGLEV_APP_DATABASE_PASSWORD: ENV.fetch('MAGLEV_APP_DATABASE_PASSWORD', '')
    },
    schema_file: 'schema.rb',
    backup_file: 'schema.pg.rb'
  },
  sqlite: {
    env: { USE_SQLITE: '1' },
    schema_file: 'schema.sqlite.rb',
    backup_file: 'schema.pg.rb'
  },
  mysql: {
    env: {
      USE_MYSQL: '1',
      MAGLEV_APP_DATABASE_HOST: ENV.fetch('MAGLEV_APP_DATABASE_HOST', '127.0.0.1'),
      MAGLEV_APP_DATABASE_USERNAME: ENV.fetch('MAGLEV_APP_DATABASE_USERNAME', 'start'),
      MAGLEV_APP_DATABASE_PASSWORD: ENV.fetch('MAGLEV_APP_DATABASE_PASSWORD', 'start')
    },
    schema_file: 'schema.mysql.rb',
    backup_file: 'schema.pg.rb'
  },
  mariadb: {
    env: {
      USE_MYSQL: '1',
      MAGLEV_APP_DATABASE_HOST: ENV.fetch('MAGLEV_APP_DATABASE_HOST', '127.0.0.1'),
      MAGLEV_APP_DATABASE_PORT: ENV.fetch('MAGLEV_APP_DATABASE_PORT', '3307'),
      MAGLEV_APP_DATABASE_USERNAME: ENV.fetch('MAGLEV_APP_DATABASE_USERNAME', 'start'),
      MAGLEV_APP_DATABASE_PASSWORD: ENV.fetch('MAGLEV_APP_DATABASE_PASSWORD', 'start')
    },
    schema_file: 'schema.mariadb.rb',
    backup_file: 'schema.pg.rb'
  }
}.freeze

GEMFILES = {
  Gemfile: 'spec/dummy',
  "Gemfile.rails_7_2": 'spec/legacy_dummy'
}.with_indifferent_access.freeze

namespace :db do
  desc 'Test all databases with all Rails versions'
  task test_all: :environment do
    all_passed = true

    GEMFILES.each do |gemfile, dummy_path|
      next unless File.exist?(gemfile)

      puts "\n#{'=' * 70}"
      puts "Testing with #{gemfile} (#{dummy_path})"
      puts '=' * 70

      # Ensure bundle is installed for this Gemfile
      unless ensure_bundle_installed(gemfile)
        puts "❌ Failed to install bundle for #{gemfile}"
        all_passed = false
        next
      end

      DATABASES.each_key do |db_name|
        success = test_database(db_name, gemfile, dummy_path)
        all_passed = false unless success

        abort "Failed testing #{db_name} with #{gemfile}" if !ENV['CONTINUE_ON_ERROR'] && !success
      end
    end

    unless all_passed
      puts "\n❌ Some tests failed. Use CONTINUE_ON_ERROR=1 to continue despite errors."
      exit 1
    end

    puts "\n✅ All tests passed!"
  end

  namespace :test do
    DATABASES.each_key do |db_name|
      desc "Test #{db_name} database with current Gemfile"
      task db_name.to_sym => :environment do
        gemfile = File.basename(ENV['BUNDLE_GEMFILE'] || 'Gemfile')
        dummy_path = GEMFILES[gemfile] || GEMFILES['Gemfile']
        success = test_database(db_name, gemfile, dummy_path)
        exit 1 unless success
      end
    end

    desc 'Test all databases with current Gemfile'
    task all: DATABASES.keys.map(&:to_sym) do
      puts "\n✅ All database tests passed!"
    end
  end

  def test_database(db_name, gemfile, dummy_path)
    puts "\n#{'-' * 70}"
    puts "Testing #{db_name} with #{gemfile}"
    puts '-' * 70

    db_config = DATABASES[db_name]

    root_dir = File.expand_path('../..', __dir__)

    db_dir = File.join(root_dir, dummy_path, 'db')
    schema_rb = File.join(db_dir, 'schema.rb')
    schema_backup = File.join(db_dir, db_config[:backup_file])
    schema_target = File.join(db_dir, db_config[:schema_file])

    # Setup environment
    env = {
      BUNDLE_GEMFILE: File.join(root_dir, gemfile),
      RAILS_ENV: 'test'
    }.merge(db_config[:env].reject { |_k, v| v.blank? })

    begin
      # Step 1: Backup current schema.rb (the PG schema) before switching databases
      if File.exist?(schema_rb) && !File.exist?(schema_backup)
        FileUtils.cp(schema_rb, schema_backup)
        puts "✓ Backed up schema.rb to #{db_config[:backup_file]}"
      end

      # Step 2: Restore appropriate schema file
      if db_name == :pg
        # For PG, restore from backup if exists, otherwise keep current schema.rb
        if File.exist?(schema_backup)
          FileUtils.cp(schema_backup, schema_rb)
          puts "✓ Restored schema from #{db_config[:backup_file]}"
        end
      elsif File.exist?(schema_target)
        # For other DBs, copy the specific schema file to schema.rb (if it exists)
        FileUtils.cp(schema_target, schema_rb)
        puts "✓ Restored schema from #{db_config[:schema_file]}"
      elsif File.exist?(schema_backup)
        # Fallback to PG schema if specific schema doesn't exist
        FileUtils.cp(schema_backup, schema_rb)
        puts "✓ Restored schema from #{db_config[:backup_file]} (fallback)"
      end

      # Step 3: Run migrations
      puts 'Running migrations...'
      unless run_command('./bin/rails db:migrate', env, root_dir)
        puts "❌ Migrations failed for #{db_name}"
        return false
      end

      # Step 4: Generate schema
      puts 'Generating schema...'
      unless run_command('bin/rails db:schema:dump', env, root_dir)
        puts "❌ Schema generation failed for #{db_name}"
        return false
      end

      # Step 5: Save generated schema to the appropriate file
      if db_name == :pg
        # For PG, keep as schema.rb (the committed version) and also backup to schema.pg.rb
        if File.exist?(schema_rb)
          FileUtils.cp(schema_rb, schema_backup)
          puts "✓ Saved schema to #{db_config[:backup_file]}"
        end
      elsif File.exist?(schema_rb)
        # For other DBs, copy generated schema.rb to the specific schema file
        FileUtils.cp(schema_rb, schema_target)
        puts "✓ Saved schema to #{db_config[:schema_file]}"
      end

      # Step 6: Run tests
      puts 'Running tests...'
      unless run_command('bundle exec rspec', env, root_dir)
        puts "❌ Tests failed for #{db_name}"
        return false
      end

      puts "✅ #{db_name} tests passed!"
      true
    rescue StandardError => e
      puts "❌ Error testing #{db_name}: #{e.message}"
      puts e.backtrace.first(5).join("\n") if ENV['DEBUG']
      false
    ensure
      # Step 7: Restore schema.rb from PG backup (for Git)
      if db_name != 'pg' && File.exist?(schema_backup)
        FileUtils.cp(schema_backup, schema_rb)
        puts '✓ Restored schema.rb from PG backup (for Git)'
      end
    end
  end

  def ensure_bundle_installed(gemfile)
    root_dir = File.expand_path('../..', __dir__)
    gemfile_path = File.join(root_dir, gemfile)

    env = {
      BUNDLE_GEMFILE: gemfile_path
    }
    full_env = ENV.to_h.merge(env).deep_stringify_keys

    puts "Checking bundle for #{gemfile}..."
    stdout, stderr, status = Open3.capture3(full_env, 'bundle check', chdir: root_dir)

    if status.success?
      puts "✓ Bundle is up to date for #{gemfile}"
      true
    else
      puts "Installing bundle for #{gemfile}..."
      stdout, stderr, status = Open3.capture3(full_env, 'bundle install', chdir: root_dir)

      if status.success?
        puts "✓ Bundle installed for #{gemfile}"
        true
      else
        puts "❌ Failed to install bundle for #{gemfile}"
        puts stderr unless stderr.empty?
        puts stdout unless stdout.empty?
        false
      end
    end
  end

  def run_command(command, env, cwd)
    full_env = ENV.to_h.merge(env).deep_stringify_keys

    stdout, stderr, status = Open3.capture3(full_env, command, chdir: cwd)

    unless status.success?
      puts "\n#{'=' * 70}"
      puts "Command failed: #{command}"
      puts "Working directory: #{cwd}"
      puts('=' * 70)

      unless stdout.empty?
        puts "\nSTDOUT:"
        puts stdout
      end

      unless stderr.empty?
        puts "\nSTDERR:"
        puts stderr
      end

      puts "\nExit status: #{status.exitstatus}"
      puts "#{'=' * 70}\n"
      return false
    end

    true
  end
end

# rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Naming/VariableNumber, Metrics/CyclomaticComplexity
