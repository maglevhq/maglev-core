# frozen_string_literal: true

module Maglev
  module Editor
    class HomeController < Maglev::Editor::BaseController
      include Maglev::BackActionConcern

      before_action :redirect_to_home_page, only: :index

      def index
        logger.info "turbo_frame_request? #{turbo_frame_request?} 🤔🤔🤔"
      end

      def destroy
        call_back_action
      end

      private

      def redirect_to_home_page
        return if params[:page_id].present?

        redirect_to editor_real_root_path(locale: I18n.locale, page_id: home_page.id)
      end

      def home_page
        # TODO: use services.search_pages.call OR a scope
        @home_page ||= Maglev::Page.home.first
      end
    end
  end
end
