# frozen_string_literal: true

module Maglev
  module Editor
    module PreviewUrlsConcern
      extend ActiveSupport::Concern

      included do
        helper_method :current_maglev_page_urls, :maglev_page_live_url, :maglev_page_preview_url
      end

      private

      def current_maglev_page_urls
        {
          path: maglev_services.get_page_fullpath.call(page: current_maglev_page, preview_mode: false,
                                                       locale: content_locale),
          preview: maglev_page_preview_url(current_maglev_page),
          live: maglev_page_live_url(current_maglev_page)
        }
      end

      def maglev_page_live_url(page)
        maglev_services.get_page_fullpath.call(page: page, preview_mode: false, locale: content_locale)
      end

      def maglev_page_preview_url(page)
        maglev_services.get_page_fullpath.call(page: page, preview_mode: true, locale: content_locale)
      end
    end
  end
end
