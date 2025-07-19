# frozen_string_literal: true

require 'rails'

module Maglev
  class CreateSiteCommand < Rails::Command::Base
    desc 'create_site', 'Create your site'

    def self.banner(_command = nil, *)
      'bin/rails maglev:create_site'
    end

    def perform
      require File.expand_path('config/environment')

      if Maglev::Site.exists?
        say '🤔 You already have a site. 🤔', :yellow
        return
      end

      Maglev::GenerateSite.call(
        theme: Maglev.local_themes.first
      )

      say '🎉 Your site has been created with success!'
    end
  end
end
