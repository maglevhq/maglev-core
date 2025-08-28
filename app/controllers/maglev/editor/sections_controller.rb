# frozen_string_literal: true

module Maglev
  module Editor
    class SectionsController < Maglev::Editor::BaseController
      def index
        fetch_sections
      end

      def new        
        @grouped_sections = maglev_theme.sections.grouped_by_category
        @position = (params[:position] || -1).to_i
      end

      def create
        @section = services.add_section.call(
          page: current_maglev_page,
          section_type: params[:section_type],
          position: params[:position].to_i
        )
        redirect_to edit_editor_section_path(@section[:id], maglev_editing_route_context), notice: flash_t(:success),
                                                                                           status: :see_other
      end

      def edit
        fetch_sections
        @section = @sections.find { |section| section.id == params[:id] }
        @section_definition = maglev_theme.sections.find(@section.type)
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
