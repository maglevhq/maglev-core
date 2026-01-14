# frozen_string_literal: true

module Maglev
  class PublishedPagePreviewController < ApplicationController
    include Maglev::RenderingConcern
    include Maglev::ContentLocaleConcern

    before_action :fetch_maglev_site
    around_action :extract_content_locale

    rescue_from Maglev::Errors::UnpublishedPage, with: :content_not_found!

    helper Maglev::PagePreviewHelper

    def index
      # use the title + SEO informations from the published payload
      maglev_page.apply_published_payload

      render_maglev_page
    end

    private

    def fetch_maglev_site
      super.tap do |site|
        raise ActiveRecord::RecordNotFound if site.nil?

        maglev_services.context.site = site
      end
    end

    def fetch_maglev_page_sections
      maglev_services.get_published_page_sections.call(page: fetch_maglev_page, locale: content_locale)
    end

    def maglev_rendering_mode
      :live
    end

    def extract_content_locale(&block)
      _, locale = maglev_services.extract_locale.call(params: params, locales: maglev_site.locale_prefixes)
      ::I18n.with_locale(locale, &block)
    end

    def fallback_to_default_locale
      false
    end

    def content_not_found!
      raise ActionController::RoutingError, 'Not Found'
    end
  end
end
