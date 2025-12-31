# frozen_string_literal: true

module Maglev
  module Editor
    class BaseController < ::Maglev::ApplicationController
      layout 'maglev/editor/application'

      default_form_builder Maglev::Form::FormBuilder

      include Maglev::AuthenticationConcern
      include Maglev::UserInterfaceLocaleConcern
      include Maglev::ContentLocaleConcern
      include Maglev::ServicesConcern
      include Maglev::FlashI18nConcern
      include Maglev::Editor::ErrorsConcern
      include Maglev::Editor::TurboConcern
      include Maglev::Editor::PreviewUrlsConcern

      before_action :fetch_maglev_site
      before_action :fetch_maglev_page
      before_action :set_content_locale

      helper Maglev::ApplicationHelper
      helper_method :maglev_site, :maglev_theme, :current_maglev_page, :current_maglev_page_content,
                    :maglev_editing_route_context, :unpublished_changes?, :maglev_number_of_pages

      private

      def fetch_maglev_site
        maglev_site # simply force the fetching of the current site
      end

      def fetch_maglev_page
        current_maglev_page
      end

      def maglev_site
        @maglev_site ||= services.fetch_site.call
      end

      def maglev_page_resources
        ::Maglev::Page
      end

      def maglev_number_of_pages
        @maglev_number_of_pages ||= maglev_page_resources.count
      end

      def current_maglev_page
        @current_maglev_page ||= maglev_page_resources.find_by(id: params[:page_id])
      end

      def maglev_home_page
        @maglev_home_page ||= maglev_page_resources.home.first
      end

      def current_maglev_page_content
        @current_maglev_page_content ||= Maglev::Content::PageContent.new(
          page: current_maglev_page,
          theme: maglev_theme,
          stores: services.get_page_sections.call(page: current_maglev_page, locale: content_locale)
        )
      end

      def unpublished_changes?
        maglev_services.has_unpublished_changes.call(site: maglev_site, page: current_maglev_page, theme: maglev_theme)
      end     

      def maglev_theme
        @maglev_theme ||= maglev_services.fetch_theme.call
      end

      def maglev_editing_route_context(page: nil, locale: nil)
        {
          locale: locale || ::Maglev::I18n.current_locale,
          page_id: page || current_maglev_page
        }.compact_blank
      end

      def redirect_to_real_root
        redirect_to editor_real_root_path(maglev_editing_route_context)
      end
    end
  end
end
