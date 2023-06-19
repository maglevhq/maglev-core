xml.instruct!

xml.urlset 'xmlns' => 'http://www.google.com/schemas/sitemap/0.9', 'xmlns:xhtml' => 'http://www.w3.org/1999/xhtml' do
  @pages.each do |page|
    xml.url do
      xml.loc "#{request.protocol}#{request.host}/#{page.path != 'index' && page.path || nil}"

      # list translations for this page as alternatives
      page.paths.select(&:canonical).each do |translation_path|
        if translation_path.locale.to_sym.in?(Maglev::I18n.available_locales) && translation_path.locale.to_sym != Maglev::I18n.default_locale
          Mobility.with_locale(translation_path.locale) do
            xml.xhtml(:link, rel: 'alternate', hreflang: translation_path.locale, href: "#{request.protocol}#{request.host}/#{translation_path.locale}/#{translation_path.value == 'index' ? '' : translation_path.value}")
          end
        end
      end

      xml.lastmod page.updated_at.to_date
      xml.changefreq 'weekly'
      xml.priority 0.6
    end
  end
end
