# frozen_string_literal: true

module Maglev
  module Editor
    module Pages
      class DiscardDraftController < Maglev::Editor::BaseController
        def create
          page = maglev_page_resources.find(params[:id])
          services.discard_page_draft.call(
            site: maglev_site,
            page: page
          )
        rescue Maglev::Errors::UnpublishedPage
          head :unprocessable_content
        end
      end
    end
  end
end
