# frozen_string_literal: true

module Maglev
  class GenerateSite
    include Injectable

    dependency(:config) { Maglev.config }
    dependency :setup_pages, class: Maglev::SetupPages

    argument :theme

    def call
      raise 'A Maglev Site already exists' if Maglev::Site.first

      Maglev::Site.transaction do
        Maglev::Site.create(name: 'Default', locales: config.default_site_locales).tap do |site|
          setup_pages.call(site: site, theme: theme) if site.errors.empty?
        end
      end
    end
  end
end
