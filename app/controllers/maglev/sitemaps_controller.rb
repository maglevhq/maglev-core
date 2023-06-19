module Maglev
  class SitemapsController < ApplicationController
    include Maglev::RenderingConcern
    include Maglev::ServicesConcern
    include Maglev::ContentLocaleConcern

    before_action :verify_request_format!
    before_action :fetch_maglev_site

    def show
      @pages = services.search_pages.call(content_locale: content_locale,
                                          default_locale: maglev_site.default_locale.prefix).select(&:visible)
    end

    protected

    def verify_request_format!
      raise ActionController::UnknownFormat, 'Sitemap is only rendered as XML' if request.format != 'xml'
    end
  end
end
