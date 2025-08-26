# frozen_string_literal: true

module Maglev
  module Editor
    class SectionsController < Maglev::Editor::BaseController
      def index
        fetch_sections
      end

      def new
        # TODO: implement it
      end

      def create
        # TODO: implement it
      end

      def edit
        # TODO: implement it
      end

      def update
        # TODO: implement it
      end

      def sort
        current_maglev_page.reorder_sections(params[:item_ids])
        if current_maglev_page.save
          redirect_to editor_sections_path(maglev_editing_route_context), notice: flash_t(:success), status: :see_other
        else
          render_index_with_error
        end
      end

      def destroy
        current_maglev_page.delete_section(params[:id])
        if current_maglev_page.save
          redirect_to editor_sections_path(maglev_editing_route_context), notice: flash_t(:success), status: :see_other
        else
          render_index_with_error
        end
      end

      private

      def fetch_sections
        @sections = Maglev::Content::SectionContent.build_many(
          theme: maglev_theme,
          content: services.get_page_sections.call(page: current_maglev_page, locale: content_locale)
        )
      end

      def render_index_with_error
        fetch_sections
        flash.now[:error] = flash_t(:error)
        render 'index', status: :unprocessable_entity
      end
    end
  end
end
