# frozen_string_literal: true

require 'rails'

module Maglev
  module Sections
    class RemoveCommand < Rails::Command::Base
      desc 'remove TYPE', 'Remove a section type across the site and its pages'

      def self.banner(_command = nil, *)
        'bin/rails maglev:sections:remove TYPE'
      end

      def perform(type)
        require File.expand_path('config/environment', Rails.root)

        site = fetch_site

        return if site.blank?

        removed_count = Maglev::RemoveSectionType.call(
          site: site,
          type: type
        )

        display_final_message(removed_count, type)
      end

      private

      def fetch_site
        Maglev::Site.first.tap do |site|
          say("[Error] You don't seem to have an existing site. 🤔", :red) unless site
        end
      end

      def display_final_message(removed_count, type)
        if removed_count.zero?
          say "No section of type '#{type}' found 🤔", :yellow
          return
        end

        say "Successfully removed #{removed_count} #{'section'.pluralize(removed_count)} of type '#{type}' 🎉",
            :green
      end
    end
  end
end
