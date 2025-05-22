# frozen_string_literal: true

module Maglev
  class PagePreviewController < ApplicationController
    include Maglev::RenderingConcern
    include Maglev::JsonConcern
    include Maglev::ContentLocaleConcern

    before_action :fetch_maglev_site
    around_action :extract_content_locale

    def index
      render_maglev_page
    end

    def create
      render_maglev_page
    end

    private

    def fetch_maglev_site
      super.tap do |site|
        raise ActiveRecord::RecordNotFound if site.nil?

        maglev_services.context.site = site

        site.style = JSON.parse(params[:style]) if params[:style]
      end
    end

    def fetch_maglev_page_sections
      return super if action_name == 'index'

      super(JSON.parse(params[:page_sections]))
    end

    def maglev_rendering_mode
      params[:rendering_mode] || super
    end

    def use_engine_vite?
      false
    end

    def extract_content_locale(&block)
      _, locale = maglev_services.extract_locale.call(params: params, locales: maglev_site.locale_prefixes)
      ::I18n.with_locale(locale, &block)
    end

    def fallback_to_default_locale
      maglev_rendering_mode == :editor
    end
  end
end
