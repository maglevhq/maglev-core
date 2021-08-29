# frozen_string_literal: true

module Maglev
  module FetchersConcern
    extend ActiveSupport::Concern

    included do
      helper_method :maglev_site, :maglev_theme, :maglev_page, :maglev_page_sections, :maglev_sections_path
    end

    private

    def fetch_page_content
      @site = fetch_site
      @theme = fetch_theme
      @page = fetch_page

      raise ActionController::RoutingError, 'Maglev page not found' unless @page

      @page_sections = fetch_page_sections
    end

    def fetch_site
      @fetch_site ||= services.fetch_site.call
    end

    def fetch_page
      @fetch_page ||= services.fetch_page.call(params: params)
    end

    def fetch_page_sections
      @fetch_page_sections ||= services.get_page_sections.call(
        page: fetch_page,
        page_sections: @page_sections
      )
    end

    def fetch_theme
      @fetch_theme ||= services.fetch_theme.call
    end

    def fetch_theme_layout
      @fetch_theme_layout ||= services.fetch_theme_layout.call
    end

    def fetch_sections_path
      @fetch_sections_path ||= services.fetch_sections_path.call
    end

    ## accessors for view helpers ##

    def maglev_site
      fetch_site
    end

    def maglev_theme
      fetch_theme
    end

    def maglev_page
      fetch_page
    end

    def maglev_page_sections
      fetch_page_sections
    end

    def maglev_sections_path
      fetch_sections_path
    end
  end
end
