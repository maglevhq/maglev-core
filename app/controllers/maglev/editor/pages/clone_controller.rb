# frozen_string_literal: true

module Maglev
  module Editor
    module Pages
      class CloneController < Maglev::Editor::BaseController
        def create
          @source_page = maglev_page_resources.find(params[:id])
          @page = clone_page(@source_page)
          edit_cloned_page_path = edit_editor_page_path(@page, maglev_editing_route_context(page: @page))
          redirect_to edit_cloned_page_path, notice: flash_t(:success), status: :see_other
        end

        private

        def clone_page(page)
          services.clone_page.call(page: page)
        end
      end
    end
  end
end
