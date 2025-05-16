# frozen_string_literal: true

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
end
