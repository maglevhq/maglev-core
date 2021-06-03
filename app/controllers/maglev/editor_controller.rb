# frozen_string_literal: true

module Maglev
  class EditorController < ApplicationController
    include Maglev::SiteConcern

    before_action :fetch_site, :fetch_page, :fetch_theme

    def show
      @site = fetch_site
      @page = fetch_page
      @theme = fetch_theme
      @page_sections = fetch_page_sections
      @home_page_id = model_scopes(:page).home.pick(:id)
      render layout: nil
      # TODO: get the current site based on what? (url, method, ...etc)
      # TODO: load the editor settings (logo, primary color, language, ...etc)
      # TODO: custom route in the main app?
    end
  end
end
