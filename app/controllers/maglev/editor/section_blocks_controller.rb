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
          page: current_maglev_page,
          section_id: @section.id,
          block_type: params[:block_type],
          parent_id: params[:parent_id]
        )
        redirect_to_section_blocks_path
      end

      def edit; end

      def update
        update_section_block
        refresh_lock_version
        flash.now[:notice] = flash_t(:success)
      end

      def sort
        services.sort_section_blocks.call(
          page: current_maglev_page,
          section_id: @section.id,
          block_ids: params[:item_ids],
          parent_id: params[:parent_id],
          lock_version: params[:lock_version]
        )
        redirect_to_section_blocks_path
      end

      def destroy
        services.delete_section_block.call(
          page: current_maglev_page,
          section_id: @section.id,
          block_id: @section_block.id
        )
        redirect_to_section_blocks_path
      end

      private

      def set_section
        @section = current_maglev_sections.find { |section| section.id == params[:section_id] }
      end

      def set_section_block
        @section_block = @section.blocks.find(params[:id])
      end

      def update_section_block
        services.update_section_block.call(
          page: current_maglev_page,
          section_id: @section.id,
          block_id: @section_block.id,
          content: params[:section_block].to_unsafe_h,
          lock_version: params[:lock_version]
        )
      end

      def refresh_lock_version
        source = @section.site_scoped? ? maglev_site : current_maglev_page
        @section_block.lock_version = source.find_section_block_by_id(
          @section.id,
          @section_block.id
        )['lock_version']
      end

      def redirect_to_section_blocks_path
        path = editor_section_blocks_path(@section.id, **maglev_editing_route_context)
        redirect_to path, notice: flash_t(:success), status: :see_other
      end
    end
  end
end
