# frozen_string_literal: true

module Maglev
  class PagePreviewController < ApplicationController
    include ::Maglev::SiteConcern
    include ::Maglev::JSONConcern

    def index
      @site = fetch_site
      @page = fetch_page
      @theme = fetch_theme
      @page_sections = fetch_page_sections
      render template: fetch_theme_layout, layout: false
    end

    def create
      @site = fetch_site
      @page = fetch_page
      @theme = fetch_theme
      @page_sections = JSON.parse(params[:page_sections])
      render template: fetch_theme_layout, layout: false
    end
  end
end
