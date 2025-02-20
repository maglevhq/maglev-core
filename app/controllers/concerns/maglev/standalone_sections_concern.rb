# frozen_string_literal: true

module Maglev
  module StandaloneSectionsConcern
    extend ActiveSupport::Concern

    included do
      include Maglev::ServicesConcern
      include Maglev::FetchersConcern
      include Maglev::ContentLocaleConcern

      helper Maglev::PagePreviewHelper

      private

      def maglev_rendering_mode
        params[:rendering_mode] || super
      end
    end

    private

    def fetch_maglev_site_scoped_sections
      return if within_maglev_engine?

      fetch_maglev_site
      fetch_maglev_theme
      fetch_maglev_dummy_page
      fetch_maglev_page_sections
    end

    def fetch_maglev_dummy_page
      @fetch_maglev_page = ::Maglev::Page.new(title: 'DummyPage', sections: fetch_maglev_site.sections)
    end

    def within_maglev_engine?
      controller_path.starts_with?('maglev/')
    end
  end
end
