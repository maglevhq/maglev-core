# frozen_string_literal: true

def ensure_log_goes_to_stdout
  old_logger = Webpacker.logger
  Webpacker.logger = ActiveSupport::Logger.new($stdout)
  yield
ensure
  Webpacker.logger = old_logger
end

namespace :maglev do
  desc 'Create site'
  task create_site: :environment do
    Maglev::GenerateSite.call(
      theme: Maglev.local_themes.first
    )
  end

  desc 'Change site locales'
  task change_site_locales: :environment do
    site = Maglev::Site.first

    unless site
      puts "[Error] You don't seem to have an existing site. 🤔"
      return
    end

    # without this, rake will run the ARGV arguments as if they were rake tasks
    # rubocop:disable Style/BlockDelimiters
    ARGV.each { |a| task a.to_sym => :environment do; end }
    # rubocop:enable Style/BlockDelimiters

    locales = ARGV[1..].map do |arg|
      label, prefix = arg.split(':')
      Maglev::Site::Locale.new(label: label, prefix: prefix)
    end

    if !locales.empty? && locales.any? { |locale| !locale.valid? }
      puts "[Error] make sure your locales follows the 'label:prefix' pattern. 🤓"
      return
    end

    if locales.empty?
      locales = Maglev.config.default_site_locales.map do |attributes|
        Maglev::Site::Locale.new(attributes)
      end
    end

    service = Maglev::ChangeSiteLocales.new

    begin
      service.call(site: site, locales: locales)
      puts 'Success! 🎉🎉🎉'
    rescue StandardError => e
      puts "[Error] #{e.message}"
    end
  end

  namespace :webpacker do
    desc 'Install deps with yarn'
    task yarn_install: :environment do
      Dir.chdir(File.join(__dir__, '..', '..')) do
        system 'yarn install --no-progress'
      end
    end

    desc 'Compile JavaScript packs using webpack for production with digests'
    task compile: %i[yarn_install environment] do
      Webpacker.with_node_env('production') do
        ensure_log_goes_to_stdout do
          if Maglev.webpacker.commands.compile
            # Successful compilation!
          else
            # Failed compilation
            exit!
          end
        end
      end
    end
  end
end

def yarn_install_available?
  rails_major = Rails::VERSION::MAJOR
  rails_minor = Rails::VERSION::MINOR

  rails_major > 5 || (rails_major == 5 && rails_minor >= 1)
end

def enhance_assets_precompile
  # yarn:install was added in Rails 5.1
  deps = yarn_install_available? ? [] : ['maglev:webpacker:yarn_install']
  Rake::Task['assets:precompile'].enhance(deps) do
    Rake::Task['maglev:webpacker:compile'].invoke
  end
end

# Compile packs after we've compiled all other assets during precompilation
skip_webpacker_precompile = %w[no false n f].include?(ENV['WEBPACKER_PRECOMPILE'])

unless skip_webpacker_precompile
  if Rake::Task.task_defined?('assets:precompile')
    enhance_assets_precompile
  else
    Rake::Task.define_task("assets:precompile": 'maglev:webpacker:compile')
  end
end
