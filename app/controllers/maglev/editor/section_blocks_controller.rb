# frozen_string_literal: true

module Maglev
  module Editor
    class SectionBlocksController < Maglev::Editor::BaseController
      before_action :set_section
      before_action :set_section_block, only: %i[edit update destroy]

      def index
        @blocks = @section.blocks
      end

      def create
        services.add_section_block.call(
          page: current_maglev_page,
          section_id: @section.id,
          block_type: params[:block_type]
        )
        redirect_to editor_section_blocks_path(@section.id, **maglev_editing_route_context), notice: flash_t(:success), status: :see_other
      end

      def edit; end

      def update
        services.update_section_block.call(
          page: current_maglev_page,
          section_id: @section.id,
          block_id: @section_block.id,
          content: params[:section_block].to_unsafe_h
        )
        flash.now[:notice] = flash_t(:success)
      end

      def sort
        services.sort_section_blocks.call(
          page: current_maglev_page,
          section_id: @section.id,
          block_ids: params[:item_ids]
        )
        redirect_to editor_section_blocks_path(@section.id, **maglev_editing_route_context), notice: flash_t(:success), status: :see_other
      end

      def destroy
        services.delete_section_block.call(
          page: current_maglev_page,
          section_id: @section.id,
          block_id: @section_block.id
        )
        redirect_to editor_section_blocks_path(@section.id, **maglev_editing_route_context), notice: flash_t(:success), status: :see_other
      end

      private

      def set_section
        @section = current_maglev_sections.find { |section| section.id == params[:section_id] }
      end

      def set_section_block
        @section_block = @section.blocks.find(params[:id])
      end
    end
  end
end
