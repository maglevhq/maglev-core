# frozen_string_literal: true

xml.instruct!

xml.urlset xmlns: 'http://www.google.com/schemas/sitemap/0.9', "xmlns:xhtml": 'http://www.w3.org/1999/xhtml' do
  @pages.each do |page|
    xml.url do
      xml.loc sitemap_url(@host, page, maglev_site.default_locale_prefix)
      xml.lastmod page.updated_at.strftime('%Y-%m-%d')

      if maglev_site.locales.size > 1
        maglev_site.locales.each do |locale|
          xml.xhtml :link,
                    rel: 'alternate',
                    hreflang: locale.prefix,
                    href: sitemap_url(@host, page, locale.prefix)
        end
      end
    end
  end
end
