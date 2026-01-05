# frozen_string_literal: true

require 'rails'

module Maglev
  class UpgradeToV3Command < Rails::Command::Base
    desc 'upgrade_to_v3', 'Upgrate the site to version 3 (layout groups & content stores)'

    def self.banner(_command = nil, *)
      'bin/rails maglev:upgrade_to_v3'
    end

    def perform
      require File.expand_path('config/environment')

      upgrade_sites

      Rails.logger.debug '🛠️ Your site/page content has been upgraded to V3 with success!'
    end

    private

    def upgrade_sites
      Maglev::Maintenance::UpgradeToV3Service.call(
        site: Maglev::Site.first,
        theme: Maglev.local_themes.first
      )
    end
  end
end
