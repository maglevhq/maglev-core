# frozen_string_literal: true

module Maglev
  class PagePreviewController < ApplicationController
    include ::Maglev::RenderingConcern
    include ::Maglev::JSONConcern

    before_action :extract_locale
    # before_action :set_maglev_locale

    def index
      render_maglev_page
    end

    def create
      render_maglev_page
    end

    private

    def fetch_maglev_page_sections
      return super if action_name == 'index'

      super(JSON.parse(params[:page_sections]))
    end

    def maglev_rendering_mode
      params[:rendering_mode] || super
    end

    def use_engine_webpacker?
      false
    end

    def extract_locale
      maglev_services.extract_locale(params, maglev_site.locale_prefixes)
      # segments = params[:path].split('/')
      # if maglev_site.locale_prefixes.include?(segments[0]&.to_sym)
      #   params[:locale] = segments.shift 
      #   params[:path] = segments.empty? ? 'index' : segments.join('/')
      # end
    end

    # def set_maglev_locale
    #   params[:default_locale] = maglev_site.default_locale.prefix
    #   Translatable.available_locales = maglev_site.locale_prefixes
    #   Translatable.current_locale = params[:locale] || params[:default_locale]
    # end

    def maglev_locale
      Translatable.current_locale
    end

    def fallback_to_default_locale
      maglev_rendering_mode == :editor
    end
  end
end
