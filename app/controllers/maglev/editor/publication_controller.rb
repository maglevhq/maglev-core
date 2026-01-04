# frozen_string_literal: true

module Maglev
  module Editor
    class PublicationController < Maglev::Editor::BaseController
      def create
        services.publish.call(
          theme: maglev_theme,
          site: maglev_site,
          page: current_maglev_page
        )
      end
    end
  end
end
