# frozen_string_literal: true

module Maglev
  module Editor
    class StyleController < Maglev::Editor::BaseController
      helper Maglev::Editor::SettingsHelper

      before_action :set_style

      def edit; end

      def update
        maglev_services.persist_style.call(new_style: style_params, lock_version: params[:lock_version])

        redirect_to edit_editor_style_path(maglev_editing_route_context),
                    notice: flash_t(:success),
                    status: :see_other
      end

      private

      def set_style
        @style = maglev_services.fetch_style.call
      end

      def style_params
        params.require(:style).permit!
      end
    end
  end
end
