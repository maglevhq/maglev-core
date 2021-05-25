# frozen_string_literal: true

module Maglev
  class PagePreviewController < ApplicationController
    include ::Maglev::SiteConcern
    include ::Maglev::JSONConcern

    def index
      @site, @page, @theme = fetch_site, fetch_page, fetch_theme
      @page_sections = fetch_page_sections
      render template: '/theme/layout', layout: false
    end

    def create
      @site, @page, @theme = fetch_site, fetch_page, fetch_theme
      @page_sections = JSON.parse(params[:page_sections])
      render template: '/theme/layout', layout: false
    end
  end
end
