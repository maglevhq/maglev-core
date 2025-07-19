# frozen_string_literal: true

require 'rails'

module Maglev
  module Sections
    class ResetCommand < Rails::Command::Base
      desc 'reset TYPE', 'Reset the content of a section type across the site and its pages'

      def self.banner(_command = nil, *)
        'bin/rails maglev:sections:reset TYPE'
      end

      def perform(type)
        require File.expand_path('config/environment', Rails.root)

        site = fetch_site
        theme = fetch_theme

        return if site.blank? || theme.blank?

        count = Maglev::ResetSectionContent.call(
          site: site,
          theme: theme,
          type: type
        )

        display_final_message(count, type)
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

      def display_final_message(count, type)
        if count.zero?
          say "No section of type '#{type}' found 🤔", :yellow
          return
        end

        say "Successfully reset content of #{count} #{'section'.pluralize(count)} of type '#{type}' 🎉",
            :green
      end
    end
  end
end
