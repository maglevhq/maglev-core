# frozen_string_literal: true

module Maglev
  module Editor
    class SectionBlocksController < Maglev::Editor::BaseController
      before_action :set_section
      before_action :set_section_block, only: %i[edit destroy]

      def index
        @blocks = @section.blocks
      end

      def new
        # TODO
      end

      def create
        # TODO
      end

      def edit; end

      def update
        # TODO
      end

      def sort
        # TODO
        head :ok
      end

      def destroy
        # TODO
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
