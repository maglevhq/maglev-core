# frozen_string_literal: true

module Maglev
  module Admin
    class ThemesController < BaseController
      helper_method :section_category_id

      def show
        @theme = services.fetch_theme.call
      end

      private

      def section_category_id
        params[:category_id].presence || @theme.section_categories.first.id
      end
    end
  end
end
