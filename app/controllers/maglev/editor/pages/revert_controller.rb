# frozen_string_literal: true

module Maglev
  module Editor
    module Pages
      class RevertController < Maglev::Editor::BaseController
        def create
          page = maglev_page_resources.find(params[:id])
          services.revert_page_changes.call(
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
