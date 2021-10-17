# frozen_string_literal: true

module Maglev
  module FetchersConcern
    extend ActiveSupport::Concern

    included do
      helper_method :maglev_site, :maglev_theme, :maglev_page, :maglev_page_sections, :maglev_sections_path
    end

    private

    def fetch_maglev_page_content
      fetch_maglev_site
      fetch_maglev_theme
      fetch_maglev_page

      raise ActionController::RoutingError, 'Maglev page not found' unless fetch_maglev_page

      fetch_maglev_page_sections
    end

    def fetch_maglev_site
      @fetch_maglev_site ||= maglev_services.fetch_site.call
    end

    def fetch_maglev_page
      @fetch_maglev_page ||= maglev_services.fetch_page.call(params: params, fallback_to_default_locale: fallback_to_default_locale)
    end

    def fetch_maglev_page_sections(page_sections = nil)
      @fetch_maglev_page_sections ||= maglev_services.get_page_sections.call(
        page: fetch_maglev_page,
        page_sections: page_sections,
        locale: Translatable.current_locale
      )
    end

    def fetch_maglev_theme
      @fetch_maglev_theme ||= maglev_services.fetch_theme.call
    end

    def fetch_maglev_theme_layout
      @fetch_maglev_theme_layout ||= maglev_services.fetch_theme_layout.call
    end

    def fetch_maglev_sections_path
      @fetch_maglev_sections_path ||= maglev_services.fetch_sections_path.call
    end

    def fallback_to_default_locale
      false
    end

    ## accessors for view helpers ##

    def maglev_site
      fetch_maglev_site
    end

    def maglev_theme
      fetch_maglev_theme
    end

    def maglev_page
      fetch_maglev_page
    end

    def maglev_page_sections
      fetch_maglev_page_sections
    end

    def maglev_sections_path
      fetch_maglev_sections_path
    end
  end
end
