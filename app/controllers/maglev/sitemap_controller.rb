# frozen_string_literal: true

module Maglev
  class SitemapController < ApplicationController
    include Maglev::FetchersConcern
    include Maglev::ServicesConcern
    include Maglev::ContentLocaleConcern

    before_action :verify_request_format!
    before_action :fetch_maglev_site

    def index
      @host = request.protocol + fetch_host
      @pages = fetch_pages
    end

    protected

    def fetch_host
      request.headers['HTTP_X_MAGLEV_HOST'] || request.host
    end

    def fetch_pages
      Maglev::Page.all.visible
    end

    def verify_request_format!
      raise ActionController::UnknownFormat, 'Sitemap is only rendered as XML' if request.format != 'xml'
    end
  end
end
