# frozen_string_literal: true

module Maglev
  module Editor
    module Pages
      class DiscardDraftController < Maglev::Editor::BaseController
        def create
          page = maglev_page_resources.find(params[:id])
          services.discard_page_draft.call(
            theme: maglev_theme,
            site: maglev_site,
            page: page
          )
        end
      end
    end
  end
end
