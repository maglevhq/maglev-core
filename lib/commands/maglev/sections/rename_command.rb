# frozen_string_literal: true

require 'rails'

module Maglev
  module Sections
    class RenameCommand < Rails::Command::Base
      desc 'rename OLD_TYPE NEW_TYPE', 'Rename a section type across the site and its pages'

      def self.banner(command = nil, *)
        'bin/rails maglev:sections:rename OLD_TYPE NEW_TYPE'
      end

      def perform(*args)
        require File.expand_path('config/environment', Rails.root)

        old_type, new_type = args

        site = fetch_site
        theme = fetch_theme

        return if site.blank? || theme.blank?

        rename_sections(site, theme, old_type, new_type)

        say "Successfully renamed all '#{old_type}' sections to '#{new_type}' 🎉", :green
      end

      private

      def fetch_site
        Maglev::Site.first.tap do |site|
          say("[Error] You don't seem to have an existing site. 🤔", :red) unless site
        end
      end

      def fetch_theme
        Maglev.local_themes&.first.tap do |theme|
          say('[Error] No theme found. 🤔', :red) unless theme
        end
      end

      def rename_sections(site, theme, old_type, new_type)
        Maglev::RenameSectionType.call(
          site: site,
          theme: theme,
          old_type: old_type,
          new_type: new_type
        )
      end
    end
  end
end
