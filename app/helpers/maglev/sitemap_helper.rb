# frozen_string_literal: true

module Maglev
  module SitemapHelper
    def sitemap_url(host, page, locale = nil)
      path = maglev_services.get_page_fullpath.call(page: page, locale: locale)

      return path if path =~ %r{^https?://}

      [host, path].join
    end
  end
end
