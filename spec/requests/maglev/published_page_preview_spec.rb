# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::PublishedPagePreviewController', type: :request do
  let(:theme) { build(:theme, :predefined_pages) }
  let!(:site) { Maglev::GenerateSite.call(theme: theme) }
  let(:home_page) { Maglev::Page.first }

  context 'the page is not published' do
    it 'returns a 404' do
      expect { get '/' }.to raise_error(ActionController::RoutingError)
    end
  end

  context 'the page is published' do
    let(:header_sections) { fetch_sections_translations('header') }
    let(:home_page_sections) { fetch_sections_translations('main', home_page.id) }
    
    before do
<<<<<<< HEAD
      Maglev::PublishService.new.call(site: site, page: home_page)
      home_page.update(title: 'Home [DRAFT]')
=======
      # super simple publish process: just create the sections content stores
      create(:sections_content_store, :published, handle: 'header', sections_translations: header_sections)
      create(:sections_content_store, :published, handle: 'main', page: home_page, sections_translations: home_page_sections)
>>>>>>> 06103aa7 (feat: minimal working version of the layout / multiple stores feature)
    end

    it 'renders the index page in the default locale' do
      get '/'
      expect(response.body).to include('<title>Default - Home</title>')
      expect(response.body).to include('<meta name="hello" content="Hello world" />')
      expect(response.body).to include('<link rel="alternate" hreflang="x-default" href="http://www.example.com">')
      expect(response.body).to include('<link rel="alternate" hreflang="en" href="http://www.example.com">')
      expect(response.body).to include('<link rel="alternate" hreflang="fr" href="http://www.example.com/fr">')
    end

    it 'renders the site the custom style' do
      get '/'
      expect(response.body).to include('--basic-theme-primary-color: #F87171;')
    end

    describe 'Given Facebook/Google/Twitter/LinkedIn crawl the index page' do
      # rubocop:disable Style/StringHashKeys
      let(:headers) { { 'HTTP_CONTENT_TYPE' => '*/*', 'HTTP_ACCEPT' => '*/*', 'HTTP_USER_AGENT' => user_agent } }
      # rubocop:enable Style/StringHashKeys

      describe 'Given Facebook crawls it' do
        let(:user_agent) { 'facebookexternalhit/1.1' }
        it 'renders the index page' do
          get '/index', headers: headers
          expect(response.body).to include('<title>Default - Home</title>')
        end
      end

      describe 'Given Twitter crawls it' do
        let(:user_agent) { 'Twitterbot' }
        it 'renders the index page' do
          get '/index', headers: headers
          expect(response.body).to include('<title>Default - Home</title>')
        end
      end

      describe 'Given Google crawls it' do
        let(:user_agent) { 'Googlebot/2.1' }
        it 'renders the index page' do
          get '/index', headers: headers
          expect(response.body).to include('<title>Default - Home</title>')
        end
      end

      describe 'Given LinkedIn crawls it' do
        let(:user_agent) { 'LinkedInBot/1.0' }
        it 'renders the index page' do
          get '/index', headers: headers
          expect(response.body).to include('<title>Default - Home</title>')
        end
      end
    end

    context 'rendering a page from its old path' do
      before do
        page = create(:page, title: 'Contact us', path: 'contact')
        page.update!(path: 'contact-us')
        create(:sections_content_store, page: page, sections: [], published: true)
      end

      it 'redirects to the canonical path of the page' do
        get '/contact'
        expect(response).to redirect_to('/contact-us')
      end
    end
  end
end
