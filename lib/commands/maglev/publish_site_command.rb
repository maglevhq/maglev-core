# frozen_string_literal: true

require 'rails'

module Maglev
  class PublishSiteCommand < Rails::Command::Base
    desc 'publish_site', 'Publish all the pages of the site'

    def self.banner(_command = nil, *)
      'bin/rails maglev:publish_site'
    end

    def perform
      require File.expand_path('config/environment')

      publish_pages(fetch_site)

      say '🎉 All the pages of the site have been published with success!'
    end

    private

    def publish_pages(site)
      fetch_pages.find_each do |page|
        Maglev::PublishService.call(
          site: site,
          page: page
        )
      end
    end

    def fetch_site
      Maglev::Site.first.tap do |site|
        say("[Error] You don't seem to have an existing site. 🤔", :red) unless site
      end
    end

    def fetch_pages
      Maglev::Page.all
    end
  end
end
