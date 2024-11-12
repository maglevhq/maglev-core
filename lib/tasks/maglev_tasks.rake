# frozen_string_literal: true

$stdout.sync = true

def within_engine_folder(&block)
  Dir.chdir(File.join(__dir__, '..', '..'), &block)
end

def within_plugin_folder(plugin, &block)
  Dir.chdir(plugin.root_path, &block)
end

namespace :maglev do
  desc 'Create site'
  task create_site: :environment do
    Maglev::GenerateSite.call(
      theme: Maglev.local_themes.first
    )
    puts '🎉 Your site has been created with success!'
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

    locales = (ARGV[1..] || []).map do |arg|
      label, prefix = arg.split(':')
      Maglev::Site::Locale.new(label:, prefix:)
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
      service.call(site:, locales:)
      puts 'Success! 🎉🎉🎉'
    rescue StandardError => e
      puts "[Error] #{e.message}"
    end
  end

  namespace :plugins do
    desc 'Uninstall all the registered plugins'
    task uninstall_all: :environment do
      Maglev.plugins.uninstall!
    end
  end

  namespace :vite do
    desc 'Bundle frontend entrypoints using ViteRuby'
    task build: :'vite:verify_install' do
      within_engine_folder do
        Maglev::Engine.vite_ruby.commands.build_from_task
      end
    end

    desc 'Bundle entrypoints using Vite Ruby (SSR only if enabled)'
    task build_all: :'vite:verify_install' do
      within_engine_folder do
        Maglev::Engine.vite_ruby.commands.build_from_task
        Maglev::Engine.vite_ruby.commands.build_from_task('--ssr') if ViteRuby.config.ssr_build_enabled
      end
    end

    desc 'Ensure build dependencies like Vite + Maglev core and plugins are installed before bundling'
    task install_dependencies: %i[install_plugins_dependencies install_engine_dependencies]

    desc 'Ensure build dependencies like Vite + MaglevCore are installed before bundling'
    task install_engine_dependencies: :environment do
      within_engine_folder do
        install_dev_dependencies = ENV['VITE_RUBY_SKIP_INSTALL_DEV_DEPENDENCIES'] == 'true'
        # rubocop:disable Style/StringHashKeys
        install_env_args = install_dev_dependencies ? {} : { 'NODE_ENV' => 'development' }
        # rubocop:enable Style/StringHashKeys
        cmd = Maglev::Engine.vite_ruby.commands.legacy_npm_version? ? 'npx ci --yes' : 'npx --yes ci'
        cmd = 'yarn install' unless Maglev.plugins.empty?
        result = system(install_env_args, cmd)
        # Fallback to `yarn` if `npx` is not available.
        system(install_env_args, 'yarn install --frozen-lockfile') if result.nil?
      end
    end

    desc 'Ensure plugin build dependencies are installed before bundling'
    task install_plugins_dependencies: :environment do
      install_dev_dependencies = ENV['VITE_RUBY_SKIP_INSTALL_DEV_DEPENDENCIES'] == 'true'
      # rubocop:disable Style/StringHashKeys
      install_env_args = install_dev_dependencies ? {} : { 'NODE_ENV' => 'development' }
      # rubocop:enable Style/StringHashKeys
      cmd = 'yarn install'
      Maglev.plugins.each do |plugin|
        within_plugin_folder(plugin) do
          system(install_env_args, cmd)
        end
      end
    end

    desc 'Verify if ViteRuby is properly installed in the app'
    task verify_install: :environment do
      within_engine_folder do
        Maglev::Engine.vite_ruby.commands.verify_install
      end
    end

    desc 'Remove old bundles created by ViteRuby'
    task :clean, %i[keep age] => :'vite:verify_install' do |_, args|
      within_engine_folder do
        Maglev::Engine.vite_ruby.commands.clean_from_task(args)
      end
    end

    desc 'Remove the build output directory for ViteRuby'
    task clobber: :'vite:verify_install' do
      within_engine_folder do
        Maglev::Engine.vite_ruby.commands.clobber
      end
    end

    desc "Provide information on ViteRuby's environment"
    task info: :environment do
      within_engine_folder do
        Maglev::Engine.vite_ruby.commands.print_info
      end
    end
  end
end

unless ENV['VITE_RUBY_SKIP_ASSETS_PRECOMPILE_EXTENSION'] == 'true'
  if Rake::Task.task_defined?('assets:precompile')
    Rake::Task['assets:precompile'].enhance do |_task|
      Rake::Task['maglev:vite:install_dependencies'].invoke
      Rake::Task['maglev:vite:build_all'].invoke
    end
  else
    Rake::Task.define_task("assets:precompile": ['maglev:vite:install_dependencies', 'maglev:vite:build_all'])
  end

  Rake::Task.define_task('assets:clean', %i[keep age]) unless Rake::Task.task_defined?('assets:clean')
  Rake::Task['assets:clean'].enhance do |_, args|
    Rake::Task['maglev:vite:clean'].invoke(*args.to_h.values)
  end

  if Rake::Task.task_defined?('assets:clobber')
    Rake::Task['assets:clobber'].enhance do
      Rake::Task['maglev:vite:clobber'].invoke
    end
  else
    Rake::Task.define_task("assets:clobber": 'maglev:vite:clobber')
  end
end
