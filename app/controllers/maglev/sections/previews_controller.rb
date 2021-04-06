# frozen_string_literal: true

module Maglev
  module Sections
    class PreviewsController < ApplicationController
      helper ::Maglev::PagePreviewHelper

      before_action :fetch_site, :fetch_theme, :fetch_page, only: [:iframe_show]

      def show; end

      def iframe_show
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
      end

      def fetch_theme
        @theme = Maglev::Theme.default
      end
    end
  end
end
