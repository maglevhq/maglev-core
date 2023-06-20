# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::SitemapController', type: :request do
  let(:theme) { build(:theme, :predefined_pages) }
  let!(:site) { Maglev::GenerateSite.call(theme: theme) }

  describe 'GET /sitemap (HTML)' do
    it 'renders an error' do
      expect { get '/sitemap.json' }.to raise_error('Sitemap is only rendered as XML')
    end
  end

  describe 'GET /sitemap.xml' do
    it 'renders a XML output' do
      get '/sitemap.xml', as: :xml
      expect(response.body.strip).to eq(<<~XML
        <?xml version="1.0" encoding="UTF-8"?>
        <urlset xmlns="http://www.google.com/schemas/sitemap/0.9" xmlns:xhtml="http://www.w3.org/1999/xhtml">
          <url>
            <loc>http://www.example.com/</loc>
            <lastmod>#{Time.zone.now.strftime('%Y-%m-%d')}</lastmod>
            <xhtml:link rel="alternate" hreflang="en" href="http://www.example.com/"/>
            <xhtml:link rel="alternate" hreflang="fr" href="http://www.example.com/fr"/>
          </url>
          <url>
            <loc>http://www.example.com/about-us</loc>
            <lastmod>#{Time.zone.now.strftime('%Y-%m-%d')}</lastmod>
            <xhtml:link rel="alternate" hreflang="en" href="http://www.example.com/about-us"/>
            <xhtml:link rel="alternate" hreflang="fr" href="http://www.example.com/fr/about-us"/>
          </url>
          <url>
            <loc>http://www.example.com/empty</loc>
            <lastmod>#{Time.zone.now.strftime('%Y-%m-%d')}</lastmod>
            <xhtml:link rel="alternate" hreflang="en" href="http://www.example.com/empty"/>
            <xhtml:link rel="alternate" hreflang="fr" href="http://www.example.com/fr/empty"/>
          </url>
        </urlset>
      XML
.strip)
    end
  end
end
