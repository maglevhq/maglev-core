# frozen_string_literal: true

module Maglev
  module Admin
    module Sections
      class PreviewsController < BaseController
        include Maglev::RenderingConcern

        helper ::Maglev::PagePreviewHelper

        def show
          @section = fetch_section
        end

        def iframe_show
          render_maglev_page
        end

        private

        def fetch_section
          @fetch_section ||= fetch_theme.sections.find(params[:id])
        end

        def fetch_page
          section_content = fetch_section.build_default_content
          Maglev::Page.new(
            title: 'Preview section',
            path: 'preview',
            sections: [section_content]
          )
        end

        def rendering_mode
          :section
        end

        def use_engine_webpacker?
          action_name == 'show'
        end
      end
    end
  end
end
