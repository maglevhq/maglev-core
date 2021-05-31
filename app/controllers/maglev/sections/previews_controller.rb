# frozen_string_literal: true

module Maglev
  module Sections
    class PreviewsController < ApplicationController
      include Maglev::SiteConcern

      helper ::Maglev::PagePreviewHelper

      def show; end

      def iframe_show
        @site = fetch_site
        @page = fetch_page
        @theme = fetch_theme
        @page_sections = fetch_page_sections
        render template: 'theme/layout', layout: false
      end

      private

      def fetch_page
        section = fetch_theme.sections.find(params[:id])
        section_content = section.build_default_content
        @page = Maglev::Page.new(
          title: 'Preview section',
          path: 'preview',
          sections: [section_content]
        )
      end

      def preview_mode?
        false
      end
    end
  end
end
