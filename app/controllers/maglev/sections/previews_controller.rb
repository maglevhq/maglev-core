# frozen_string_literal: true

module Maglev
  module Sections
    class PreviewsController < ApplicationController
      helper ::Maglev::PagePreviewHelper

      before_action :fetch_site, :fetch_theme, :fetch_page, only: [:iframe_show]
      helper_method :preview_mode?

      def show; end

      def iframe_show
        # TODO: theme.layout_path?
        render template: 'theme/layout', layout: false
      end

      private

      def fetch_site
        @site = ::Maglev::Site.new(name: 'Maglev Preview site')
      end

      def fetch_page
        section = @theme.sections.find(params[:id])
        @page = Maglev::Page.new(title: 'Preview section', path: 'preview', sections: [
                                   section.build_default_content
                                 ])
        @page.site = @site
      end

      def fetch_theme
        @theme = Maglev.theme
      end

      def preview_mode?
        false
      end
    end
  end
end
