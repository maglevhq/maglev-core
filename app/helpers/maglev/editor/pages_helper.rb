# frozen_string_literal: true

module Maglev
  module Editor
    module PagesHelper
      def maglev_edit_page_title(page)
        if current_maglev_page == page
          t('maglev.editor.pages.edit.current_page.title')
        else
          t('maglev.editor.pages.edit.title')
        end
      end

      def maglev_page_back_path
        if query_params.present?
          editor_pages_path(**query_params, **maglev_editing_route_context)
        else
          editor_real_root_path(**maglev_editing_route_context)
        end
      end
    end
  end
end
