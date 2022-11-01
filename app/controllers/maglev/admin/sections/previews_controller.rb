# frozen_string_literal: true

module Maglev
  module Admin
    module Sections
      class PreviewsController < BaseController
        include Maglev::RenderingConcern
        include Maglev::ContentLocaleConcern

        helper ::Maglev::PagePreviewHelper

        def show
          @section = fetch_section
        end

        def iframe_show
          render_maglev_page
        end

        private

        def fetch_maglev_page
          Maglev::Page.new(
            title: 'Preview section',
            path: 'preview',
            sections: [fetch_section!.build_default_content]
          )
        end

        def fetch_section!
          fetch_section || (raise ::Maglev::Errors::UnknownSection, "Unknown section #{params[:id]}")
        end

        def fetch_section
          @fetch_section ||= fetch_maglev_theme.sections.find(params[:id])
        end

        def maglev_rendering_mode
          :section
        end

        def use_engine_vite?
          action_name == 'show'
        end

        def content_locale
          default_content_locale
        end
      end
    end
  end
end
