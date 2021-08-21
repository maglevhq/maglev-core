# frozen_string_literal: true

module Maglev
  module FetchersConcern
    extend ActiveSupport::Concern

    included do
      helper_method :fetch_sections_path
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
  end
end
