# frozen_string_literal: true

module Maglev
  module Editor
    class HomeController < Maglev::Editor::BaseController
      include Maglev::BackActionConcern

      before_action :redirect_to_maglev_home_page, only: :index

      def index; end

      def destroy
        call_back_action
      end

      private

      def redirect_to_maglev_home_page
        return if params[:page_id].present?

        redirect_to editor_real_root_path(maglev_editing_route_context(page: maglev_home_page))
      end
    end
  end
end
