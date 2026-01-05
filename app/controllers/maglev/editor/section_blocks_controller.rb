# frozen_string_literal: true

module Maglev
  module Editor
    class SectionBlocksController < Maglev::Editor::BaseController
      helper Maglev::Editor::SettingsHelper

      before_action :set_section
      before_action :set_section_block, only: %i[edit update destroy]

      def index
        @blocks = @section.blocks
      end

      def show
        redirect_to edit_editor_section_block_path(params[:section_id], params[:id], maglev_editing_route_context)
      end

      def create
        services.add_section_block.call(
          store: sections_store,
          section_id: @section.id,
          block_type: params[:block_type],
          parent_id: params[:parent_id],
          lock_version: params[:lock_version]
        )
        redirect_to_section_blocks_path
      end

      def edit; end

      def update
        update_section_block
        refresh_lock_version
        current_maglev_page.reload # reload the page to get the updated published_at
        flash.now[:notice] = flash_t(:success)
      end

      def destroy
        services.delete_section_block.call(
          store: sections_store,
          section_id: params[:section_id],
          block_id: params[:id]
        )
        redirect_to_section_blocks_path
      end

      def sort
        services.sort_section_blocks.call(
          store: sections_store,
          section_id: @section.id,
          block_ids: params[:item_ids],
          parent_id: params[:parent_id],
          lock_version: params[:lock_version]
        )
        redirect_to_section_blocks_path
      end

      private

      def set_section
        @section = current_maglev_page_content.find_section(params[:section_id])
        redirect_to editor_sections_path_with_context unless @section
      end

      def set_section_block
        @section_block = @section.blocks.find(params[:id])
        redirect_to editor_sections_path_with_context unless @section_block
      end

      def sections_store
        @sections_store ||= services.fetch_sections_store.call(page: current_maglev_page, handle: @section.store_handle)
      end

      def update_section_block
        services.update_section_block.call(
          store: sections_store,
          section_id: @section.id,
          block_id: @section_block.id,
          content: params[:section_block].to_unsafe_h,
          lock_version: params[:lock_version]
        )
      end

      def refresh_lock_version
        @section_block.lock_version = sections_store.find_section_block_by_id(@section.id,
                                                                              @section_block.id)['lock_version']
      end

      def redirect_to_section_blocks_path(success: true)
        flash = case success
                when true then { notice: flash_t(:success) }
                when false then { alert: flash_t(:error) }
                else {}
                end

        path = editor_section_blocks_path(@section.id, **maglev_editing_route_context)

        redirect_to path, status: :see_other, **flash
      end

      def editor_sections_path_with_context
        editor_sections_path(maglev_editing_route_context)
      end
    end
  end
end
