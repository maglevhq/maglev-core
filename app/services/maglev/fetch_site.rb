# frozen_string_literal: true

module Maglev
  # Fetch the site and set up the Translatable available locales
  class FetchSite    
    include Injectable

    def call
      Maglev::Site.first.tap do |site|
        set_default_locales(site)
      end
    end

    private

    def set_default_locales(site)
      Maglev::Translatable.available_locales = site.locale_prefixes
    end
  end
end
