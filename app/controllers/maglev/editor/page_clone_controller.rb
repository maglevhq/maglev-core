# frozen_string_literal: true

module Maglev
  module Editor
    class PageCloneController < Maglev::Editor::BaseController
      def create
        @source_page = maglev_page_resources.find(params[:page_id])
        @page = clone_page(@source_page)
        redirect_to edit_editor_page_path(@page, maglev_editing_route_context(page: @page)), notice: flash_t(:success),
                                                                                             status: :see_other
      end

      private

      def clone_page(page)
        services.clone_page.call(page: page)
      end
    end
  end
end
