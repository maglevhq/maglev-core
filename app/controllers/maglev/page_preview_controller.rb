# frozen_string_literal: true

module Maglev
  class PagePreviewController < ApplicationController
    include ::Maglev::SiteConcern
    include ::Maglev::JSONConcern

    before_action :fetch_site, :fetch_page, :fetch_theme

    def index
      render template: '/theme/layout', layout: false
    end

    def create
      @page.sections = JSON.parse(params[:page_sections])
      render template: '/theme/layout', layout: false
    end
  end
end
