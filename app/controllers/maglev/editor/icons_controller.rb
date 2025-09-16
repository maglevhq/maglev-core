# frozen_string_literal: true

module Maglev
  module Editor
    class IconsController < Maglev::Editor::BaseController
      before_action :ensure_turbo_frame_request, only: [:index]

      helper_method :query_params

      layout false

      def index
        @icons = maglev_theme.icons
        @icons = @icons.find_all { |icon| icon.include?(params[:query]) } if params[:query].present?
      end

      private

      def query_params
        { query: params[:query], source: params[:source] }
      end
    end
  end
end
