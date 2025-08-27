# frozen_string_literal: true

module Maglev
  module Api
    class PageTranslationsController < ::Maglev::ApiController
      def create
        @page = translate_page(resources.find(params[:page_id]))
      end

      private

      def translate_page(page)
        services.translate_page.call(
          page: page, 
          locale: params[:locale], 
          source_locale: maglev_site.default_locale_prefix.to_s
        )
      end

      def resources
        ::Maglev::Page
      end
    end
  end
end
