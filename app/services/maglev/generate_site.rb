# frozen_string_literal: true

module Maglev
  class GenerateSite
    include Injectable

    dependency :setup_pages, class: Maglev::SetupPages

    argument :theme

    def call
      raise 'A Maglev Site already exists' if Maglev::Site.first

      Maglev::Site.transaction do
        Maglev::Site.create(name: 'Default').tap do |site|
          setup_pages.call(site: site, theme: theme)
        end
      end
    end
  end
end
