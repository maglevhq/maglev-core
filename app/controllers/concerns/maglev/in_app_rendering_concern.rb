# frozen_string_literal: true

module Maglev
  module InAppRenderingConcern
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

    def fetch_maglev_sections_content(layout_id: nil)
      return if within_maglev_engine?

      fetch_maglev_site
      fetch_maglev_theme
      fetch_maglev_dummy_page(layout_id)
      fetch_maglev_page_sections
    end

    def fetch_maglev_dummy_page(layout_id = nil)
      @fetch_maglev_page = ::Maglev::Page.new(
        title: 'DummyPage',
        layout_id: layout_id || maglev_layout_id
      )
    end

    def within_maglev_engine?
      controller_path.starts_with?('maglev/')
    end

    def maglev_layout_id
      nil
    end
  end
end
