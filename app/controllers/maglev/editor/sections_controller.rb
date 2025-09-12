# frozen_string_literal: true

module Maglev
  module Editor
    class SectionsController < Maglev::Editor::BaseController
      before_action :set_section, only: %i[edit update]

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
        redirect_to edit_editor_section_path(@section[:id], maglev_editing_route_context),
                    flash: newly_added_section_to_flash,
                    notice: flash_t(:success),
                    status: :see_other
      end

      def edit
        newly_added_section_to_headers
      end

      def update
        services.update_section.call(
          page: current_maglev_page,
          section_id: @section.id,
          content: params[:section].to_unsafe_h
        )
        flash.now[:notice] = flash_t(:success)
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

      def render_index_with_error
        flash.now[:error] = flash_t(:error)
        render 'index', status: :unprocessable_content
      end

      def set_section
        @section = current_maglev_sections.find { |section| section.id == params[:id] }
      end

      def newly_added_section_to_flash
        # use flash because we can't pass directly the information to the redirect
        { section_id: @section[:id], position: params[:position].to_i }
      end

      def newly_added_section_to_headers
        headers['X-Section-Id'] = flash[:section_id]
        headers['X-Section-Position'] = flash[:position]
      end
    end
  end
end
