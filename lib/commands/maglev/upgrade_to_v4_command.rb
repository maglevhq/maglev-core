# frozen_string_literal: true

require 'rails'

module Maglev
  class UpgradeToV4Command < Rails::Command::Base
    desc 'upgrade_to_v4', 'Upgrade the site to version 4 (layout groups & content stores)'

    def self.banner(_command = nil, *)
      'bin/rails maglev:upgrade_to_v4'
    end

    def perform
      require File.expand_path('config/environment')

      upgrade_sites

      Rails.logger.debug '🛠️ Your site/page content has been upgraded to V4 with success!'
    end

    private

    def upgrade_sites
      Maglev::Maintenance::UpgradeToV4Service.call(
        site: Maglev::Site.first,
        theme: Maglev.local_themes.first
      )
    end
  end
end
