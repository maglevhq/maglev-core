# frozen_string_literal: true

module Maglev
  module Api
    class PageTranslationsController < ::Maglev::ApiController
      before_action :set_page

      def index
        translations = @page.translations_for(:sections, params[:locale])
        render json: { translated: translations&.size.to_i > 0 }
      end

      def create
        translate_page(@page)
        head :ok
      end

      private

      def set_page
        @page ||= resources.find(params[:page_id])
      end

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
