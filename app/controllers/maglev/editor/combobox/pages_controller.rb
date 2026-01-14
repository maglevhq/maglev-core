# frozen_string_literal: true

module Maglev
  module Editor
    module Combobox
      class PagesController < Maglev::Editor::BaseController
        def index
          @pages = services.search_pages.call(
            q: params[:query],
            content_locale: content_locale,
            default_locale: default_content_locale,
            with_static_pages: params[:static_pages].blank? || params[:static_pages] == '1',
            index_first: true
          )
          response.set_header('X-Select-Options-Size', @pages.size)
        end
      end
    end
  end
end
