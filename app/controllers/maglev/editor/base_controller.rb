# frozen_string_literal: true

module Maglev
  module Editor
    class BaseController < ::Maglev::ApplicationController
      layout 'maglev/editor/application'

      default_form_builder Maglev::Form::FormBuilder

      include Maglev::UserInterfaceLocaleConcern
      include Maglev::ContentLocaleConcern
      include Maglev::ServicesConcern
      include Maglev::FlashI18nConcern

      before_action :fetch_maglev_site
      before_action :fetch_maglev_page
      before_action :set_content_locale

      helper Maglev::ApplicationHelper
      helper_method :maglev_site, :maglev_theme,
                    :current_maglev_page, :current_maglev_sections, :current_maglev_page_urls,
                    :maglev_editing_route_context, :maglev_disable_turbo_cache?, :maglev_page_live_url

      private

      def fetch_maglev_site
        maglev_site # simply force the fetching of the current site
      end

      def fetch_maglev_page
        current_maglev_page
      end

      def fetch_maglev_sections
        current_maglev_sections
      end

      def maglev_site
        @maglev_site ||= services.fetch_site.call
      end

      def maglev_page_resources
        ::Maglev::Page
      end

      def current_maglev_page
        @current_maglev_page ||= maglev_page_resources.find_by(id: params[:page_id])
      end

      def current_maglev_sections
        @current_maglev_sections = Maglev::Content::SectionContent.build_many(
          theme: maglev_theme,
          content: services.get_page_sections.call(page: current_maglev_page, locale: content_locale)
        )
      end

      def current_maglev_page_urls
        {
          path: maglev_services.get_page_fullpath.call(page: current_maglev_page, preview_mode: false,
                                                       locale: content_locale),
          preview: maglev_services.get_page_fullpath.call(page: current_maglev_page, preview_mode: true,
                                                          locale: content_locale),
          live: maglev_page_live_url(current_maglev_page)
        }
      end

      def maglev_page_live_url(page)
        maglev_services.get_page_fullpath.call(page: page, preview_mode: false, locale: content_locale)
      end

      def maglev_theme
        @maglev_theme ||= maglev_services.fetch_theme.call
      end

      def maglev_editing_route_context(page: nil, locale: nil)
        {
          locale: locale || ::Maglev::I18n.current_locale,
          page_id: page || current_maglev_page
        }
      end

      def maglev_disable_turbo_cache
        @maglev_disable_turbo_cache = true
      end

      def maglev_disable_turbo_cache?
        !!@maglev_disable_turbo_cache
      end

      def ensure_turbo_frame_request
        return if turbo_frame_request?

        redirect_to editor_root_path
      end
    end
  end
end
