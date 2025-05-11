# frozen_string_literal: true

$stdout.sync = true

def within_engine_folder(&block)
  Dir.chdir(File.join(__dir__, '..', '..'), &block)
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

    desc 'Ensure build dependencies like Vite are installed before bundling'
    task install_dependencies: :environment do
      within_engine_folder do
        install_dev_dependencies = ENV['VITE_RUBY_SKIP_INSTALL_DEV_DEPENDENCIES'] == 'true'
        # rubocop:disable Style/StringHashKeys
        install_env_args = install_dev_dependencies ? {} : { 'NODE_ENV' => 'development' }
        # rubocop:enable Style/StringHashKeys
        cmd = Maglev::Engine.vite_ruby.commands.legacy_npm_version? ? 'npx ci --yes' : 'npx --yes ci'
        result = system(install_env_args, cmd)
        # Fallback to `yarn` if `npx` is not available.
        system(install_env_args, 'yarn install --frozen-lockfile') if result.nil?
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

  namespace :icons do
    desc 'Generate FontAwesome icon configuration for Maglev'
    task fontawesome: :environment do
      require 'net/http'
      require 'uri'

      puts 'Fetching FontAwesome icons from CDN...'

      # Fetch the all.css file from FontAwesome CDN
      uri = URI('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.css')
      response = Net::HTTP.get(uri)

      # Extract icon classes using regex
      icon_classes = []

      # Match .fa-* classes that define content
      response.scan(/\.(fa-[^:]+):before/).each do |match|
        class_name = match[0]
        next if class_name.include?('{') || class_name.include?('}') # Skip utility classes

        # Add each style variant
        %w[fa-solid fa-regular fa-light fa-thin fa-brands].each do |style|
          # Extract the icon name without fa- prefix
          icon_name = class_name.sub('fa-', '')
          icon_classes << "#{style} fa-#{icon_name}"
        end
      end

      # Remove duplicates and sort
      icon_classes.uniq!
      icon_classes.sort!

      puts "Found #{icon_classes.size} icon variations"

      # Generate the icons YAML content in a single line
      icons_yaml = ['', '', '# FontAwesome icons', "icons: [#{icon_classes.map { |i| %("#{i}") }.join(', ')}]"]
      icons_yaml = icons_yaml.join("\n")

      # Append to theme.yml
      theme_file = Rails.root.join('app/theme/theme.yml')

      if File.exist?(theme_file)
        # Read the current content
        content = File.read(theme_file)

        # Check if icons are already defined
        if content.match?(/^icons:/)
          puts "Warning: 'icons' section already exists in #{theme_file}"
          puts "Please remove the existing 'icons' section first"
          puts 'You can add the following content to your theme.yml file:'
          puts icons_yaml
        else
          # Append the icons section
          File.write(theme_file, [content.rstrip, icons_yaml, "\n"].join)
          puts "Updated #{theme_file} with FontAwesome icons"
        end
      else
        puts "Warning: #{theme_file} not found. Please create a theme first."
        puts 'You can add the following content to your theme.yml file:'
        puts icons_yaml
      end
    end

    desc 'Generate Remixicon icon configuration for Maglev'
    task remixicon: :environment do
      require 'net/http'
      require 'uri'

      puts 'Fetching Remixicon icons from CDN...'

      # Fetch the remixicon.css file from CDN
      uri = URI('https://cdn.jsdelivr.net/npm/remixicon@3.7.0/fonts/remixicon.css')
      response = Net::HTTP.get(uri)

      # Extract icon classes using regex
      icon_classes = []

      # Match .ri-* classes that define content
      response.scan(/\.(ri-[^:]+):before/).each do |match|
        class_name = match[0]
        next if class_name.include?('{') || class_name.include?('}') # Skip utility classes

        icon_classes << class_name
      end

      icon_classes.uniq!
      icon_classes.sort!

      puts "Found #{icon_classes.size} Remixicon icons"

      # Generate the icons YAML content in a single line
      icons_yaml = ['', '', '# Remixicon icons', "icons: [#{icon_classes.map { |i| %("#{i}") }.join(', ')}]"]
      icons_yaml = icons_yaml.join("\n")

      # Append to theme.yml
      theme_file = Rails.root.join('app/theme/theme.yml')

      if File.exist?(theme_file)
        # Read the current content
        content = File.read(theme_file)

        # Check if icons are already defined
        if content.match?(/^icons:/)
          puts "Warning: 'icons' section already exists in #{theme_file}"
          puts "Please remove the existing 'icons' section first"
          puts 'You can add the following content to your theme.yml file:'
          puts icons_yaml
        else
          # Append the icons section
          File.write(theme_file, [content.rstrip, icons_yaml, "\n"].join)
          puts "Updated #{theme_file} with Remixicon icons"
        end
      else
        puts "Warning: #{theme_file} not found. Please create a theme first."
        puts 'You can add the following content to your theme.yml file:'
        puts icons_yaml
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

  if Rake::Task.task_defined?('assets:clobber')
    Rake::Task['assets:clobber'].enhance do
      Rake::Task['maglev:vite:clobber'].invoke
    end
  else
    Rake::Task.define_task("assets:clobber": 'maglev:vite:clobber')
  end
end
