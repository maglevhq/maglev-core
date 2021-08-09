# frozen_string_literal: true

module Maglev
  module RenderingConcern
    extend ActiveSupport::Concern

    included do
      include Maglev::FetchersConcern
    end

    def render_maglev_page
      if request.format != 'html'
        raise ActionController::UnknownFormat, 'Maglev renders HTML pages only'
      end

      fetch_page_content
      render template: fetch_theme_layout, layout: false
    end
  end
end
