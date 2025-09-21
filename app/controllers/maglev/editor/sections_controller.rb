# frozen_string_literal: true

module Maglev
  module Editor
    class SectionsController < Maglev::Editor::BaseController
      helper Maglev::Editor::SettingsHelper

      before_action :set_section, only: %i[edit update]

      rescue_from Maglev::Errors::UnknownSection, with: :redirect_to_real_root

      def show
        redirect_to edit_editor_section_path(params[:id], maglev_editing_route_context)
      end

      def new
        @grouped_sections = maglev_theme.sections.available_for(current_maglev_sections).grouped_by_category
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
        update_section
        refresh_lock_version
        flash.now[:notice] = flash_t(:success)
      end

      def sort
        current_maglev_page.reorder_sections(params[:item_ids], params[:lock_version])
        if current_maglev_page.save
          redirect_to_sections_path
        else
          render_index_with_error
        end
      end

      def destroy
        services.delete_section.call(page: current_maglev_page, section_id: params[:id])
        redirect_to_sections_path
      end

      private

      def set_section
        @section = current_maglev_sections.find { |section| section.id == params[:id] }
        raise Maglev::Errors::UnknownSection unless @section
      end

      def update_section
        services.update_section.call(
          page: current_maglev_page,
          section_id: @section.id,
          content: params[:section].to_unsafe_h,
          lock_version: params[:lock_version]
        )
      end

      def render_index_with_error
        flash.now[:alert] = flash_t(:error)
        render 'index', status: :unprocessable_content
      end

      def newly_added_section_to_flash
        # use flash because we can't pass directly the information to the redirect
        { section_id: @section[:id], position: params[:position].to_i }
      end

      def newly_added_section_to_headers
        headers['X-Section-Id'] = flash[:section_id]
        headers['X-Section-Position'] = flash[:position]
      end

      def refresh_lock_version
        source = @section.site_scoped? ? maglev_site : current_maglev_page
        @section.lock_version = source.find_section_by_id(@section.id)['lock_version']
      end

      def redirect_to_sections_path
        redirect_to editor_sections_path(maglev_editing_route_context), notice: flash_t(:success), status: :see_other
      end
    end
  end
end
