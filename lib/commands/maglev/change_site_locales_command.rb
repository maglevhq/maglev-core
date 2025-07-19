# frozen_string_literal: true

require 'rails'

module Maglev
  class ChangeSiteLocalesCommand < Rails::Command::Base
    desc 'change_site_locales [LOCALES]', 'Change site locales (format: label:prefix)'

    def self.banner(_command = nil, *)
      'bin/rails maglev:change_site_locales [label:prefix label2:prefix2 ...]'
    end

    def perform(*locale_args)
      require File.expand_path('config/environment', Rails.root)

      site = fetch_site
      return if site.blank?

      locales = build_locales(locale_args)
      return if locales.empty?

      update_site_locales(site, locales)
    end

    private

    def fetch_site
      Maglev::Site.first.tap do |site|
        say("[Error] You don't seem to have an existing site. 🤔", :red) unless site
      end
    end

    def build_locales(locale_args)
      build_custom_locales(locale_args).tap do |locales|
        validate_locales(locales)
      end
    end

    def build_custom_locales(locale_args)
      (locale_args || []).map do |arg|
        label, prefix = arg.split(':')
        Maglev::Site::Locale.new(label: label, prefix: prefix)
      end
    end

    def validate_locales(locales)
      return true if !locales.empty? && locales.all?(&:valid?)

      say("[Error] make sure your locales follow the 'label:prefix' pattern. 🤓", :red)
      false
    end

    def update_site_locales(site, locales)
      Maglev::ChangeSiteLocales.call(
        site: site,
        locales: locales
      )
      say('Success! 🎉🎉🎉', :green)
    end
  end
end
