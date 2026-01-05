# frozen_string_literal: true

module Maglev
  module Editor
    class SectionsController < Maglev::Editor::BaseController
      helper Maglev::Editor::SettingsHelper

      before_action :set_section, only: %i[edit update destroy]
      before_action :set_sections_store_content, only: %i[new create]

      def show
        redirect_to edit_editor_section_path(params[:id], maglev_editing_route_context)
      end

      def new
        # here, sections are the available section definitions for the given store
        @grouped_sections = maglev_theme.sections.available_for(@sections_store_content).group_by_category
        @position = (params[:position] || -1).to_i
      end

      def create
        @section = create_section
        redirect_to edit_editor_section_path(@section[:id], maglev_editing_route_context),
                    flash: newly_added_section_to_flash,
                    notice: flash_t(:success),
                    status: :see_other
      end

      def edit
        if @section.mirrored?
          redirect_to editor_mirrored_section_path(@section, store_id: @section.store_handle,
                                                             **maglev_editing_route_context) and return
        end

        newly_added_section_to_headers
      end

      def update
        update_section
        refresh_lock_version
        current_maglev_page.reload # reload the page to get the updated published_at
        flash.now[:notice] = flash_t(:success)
      end

      def destroy
        services.delete_section.call(store: sections_store, section_id: @section.id)
        redirect_to_sections_path
      end

      def sort
        services.sort_sections.call(store: sections_store, section_ids: params[:item_ids],
                                    lock_version: params[:lock_version])
        redirect_to_sections_path
      end

      private

      def store_handle
        params[:store_id] || @section.store_handle
      end

      def set_sections_store_content
        @sections_store_content = current_maglev_page_content.find_store(params[:store_id])
      end

      def set_section
        @section = current_maglev_page_content.find_section(params[:id])
        redirect_to editor_sections_path_with_context unless @section
      end

      def sections_store
        @sections_store ||= services.fetch_sections_store.call(page: current_maglev_page, handle: store_handle)
      end

      def create_section
        services.add_section.call(
          store: sections_store,
          layout_id: current_maglev_page.layout_id,
          section_type: params[:section_type],
          position: params[:position].to_i
        )
      end

      def update_section
        services.update_section.call(
          store: sections_store,
          section_id: @section.id,
          content: params[:section].to_unsafe_h,
          lock_version: params[:lock_version]
        )
      end

      def refresh_lock_version
        @section.lock_version = sections_store.find_section_by_id(@section.id)['lock_version']
      end

      def newly_added_section_to_flash
        # use flash because we can't pass directly the information to the redirect
        { store_id: params[:store_id], section_id: @section[:id],
          position: sections_store.position_of_section(@section[:id]) }
      end

      def newly_added_section_to_headers
        headers['X-Layout-Store-Id'] = flash[:store_id]
        headers['X-Section-Id'] = flash[:section_id]
        headers['X-Section-Position'] = flash[:position]
      end

      def redirect_to_sections_path
        redirect_to editor_sections_path_with_context, notice: flash_t(:success), status: :see_other
      end

      def editor_sections_path_with_context
        editor_sections_path(maglev_editing_route_context)
        redirect_to editor_sections_stores_path(maglev_editing_route_context), notice: flash_t(:success), status: :see_other
      end
    end
  end
end
