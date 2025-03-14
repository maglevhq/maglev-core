# frozen_string_literal: true

module Maglev
  module Api
    class SectionsContentController < ::Maglev::ApiController
      before_action :set_page

      def show
        @sections_content = maglev_services.get_page_sections.call(
          page: @page,
          locale: content_locale
        )
      end

      def update
        @stores = services.persist_sections_content.call(
          site: maglev_site,
          page: @page,
          sections_content: sections_content_params
        )
      end

      private

      def set_page
        @page = resources.find(params[:page_id])
      end

      def sections_content_params
        params.to_unsafe_hash[:sections_content]
      end

      def resources
        ::Maglev::Page
      end
    end
  end
end