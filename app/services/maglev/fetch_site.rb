# frozen_string_literal: true

module Maglev
  class FetchSite
    include Injectable

    def call
      Maglev::Site.first.tap do |site|
        set_default_locales(site)
      end
    end

    private

    def set_default_locales(site)
      Translatable.available_locales = site.locale_prefixes
    end
  end
end
