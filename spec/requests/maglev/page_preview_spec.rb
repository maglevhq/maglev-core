# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::PagePreviewController', type: :request do
  let(:theme) { build(:theme, :predefined_pages) }
  let!(:site) do
    Maglev::GenerateSite.call(theme: theme)
  end
  let(:home_page) { Maglev::Page.first }

  context 'normal rendering' do
    # rubocop:disable Layout/LineLength
    it 'renders the index page in the default locale' do
      get '/maglev/preview'
      expect(response.body).to include('<title>Default - Home</title>')
      expect(response.body).to include('<meta name="hello" content="Hello world" />')
      expect(response.body).to include('<link rel="alternate" hreflang="x-default" href="http://www.example.com/maglev/preview">')
      expect(response.body).to include('<link rel="alternate" hreflang="en" href="http://www.example.com/maglev/preview">')
      expect(response.body).to include('<link rel="alternate" hreflang="fr" href="http://www.example.com/maglev/preview/fr">')
      expect(response.body).to match(%r{<h1 data-maglev-id="\S+\.title" class="display-3">Let's create the product<br/>your clients<br/>will love\.</h1>})
      expect(response.body).to include('Our projects')
    end
    # rubocop:enable Layout/LineLength

    context 'live site' do
      it 'renders the index page in the default locale' do
        get '/'
        expect(response.body).to include('<title>Default - Home</title>')
        expect(response.body).to include('<meta name="hello" content="Hello world" />')
        expect(response.body).to include('<link rel="alternate" hreflang="x-default" href="http://www.example.com/">')
        expect(response.body).to include('<link rel="alternate" hreflang="en" href="http://www.example.com/">')
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
    end

    context 'with scoped site sections' do
      before do
        home_page.update!(
          sections: attributes_for(:page, :with_navbar)[:sections]
        )
        site.update!(
          sections: attributes_for(:site, :with_navbar)[:sections]
        )
      end

      it 'renders the index page with the navbar' do
        get '/maglev/preview'
        expect(response.body).to include('<title>Default - Home</title>')
        expect(response.body).to include('<a data-maglev-id="zzz.link" target="_blank" href="https://www.nocoffee.fr">')
      end
    end
  end

  context 'requesting the page in a different locale' do
    before { Maglev::I18n.with_locale(:fr) { home_page.update!(title: 'Bonjour !', path: 'index') } }

    it 'renders the page in the locale' do
      get '/maglev/preview/fr'
      expect(response.body).to include('<title>Default - Bonjour !</title>')
      expect(response.body).to include('<meta name="hello" content="Bonjour le monde" />')
    end
  end

  context 'rendering a page from its old path' do
    before do
      page = Maglev::Page.create(title: 'Contact us', path: 'contact')
      page.update!(path: 'contact-us')
    end

    context 'inside the editor UI' do
      it 'redirects to the canonical path of the page' do
        get '/maglev/preview/contact'
        expect(response).to redirect_to('/maglev/preview/contact-us')
      end
    end

    context 'live site' do
      it 'redirects to the canonical path of the page' do
        get '/contact'
        expect(response).to redirect_to('/contact-us')
      end
    end
  end

  context 'rendering an unknown page' do
    it 'raises a routing error' do
      expect do
        get '/maglev/preview/unknown-page'
      end.to raise_error('Maglev page not found')
    end
  end

  context 'requesting a non HTML resource' do
    it 'lets Rails handle this' do
      expect do
        get '/maglev/preview/unkown-image.jpg', headers: { "Content-Type": 'image/jpeg' }
      end.to raise_error(ActionController::RoutingError)
    end
  end

  context 'rendering from POST params' do
    let(:sections) do
      Maglev::Page.all.order_by_translated(:title, :desc)[2].sections.tap do |sections|
        sections.first['settings'].first['value'] = 'UPDATED TITLE'
      end
    end

    it 'renders the index page with the content from the params' do
      post '/maglev/preview', params: { page_sections: sections.to_json }
      expect(response.body).to match(%r{<h1 data-maglev-id="\S+\.title" class="display-3">UPDATED TITLE</h1>})
    end
  end

  context 'rendering a section with blocks' do
    let(:page) { Maglev::Page.first }
    let(:showcase) { page.sections.find { |section| section['type'] == 'showcase' } }
    let(:block) do
      { id: 'block-0', type: 'item',
        settings: [{ id: 'title', value: 'My work' }, { id: 'image', value: '/samples/images/default.svg' }] }
    end

    before do
      showcase['blocks'] << block
      page.save
    end

    # rubocop:disable Layout/LineLength
    it 'displays the expected content' do
      get '/maglev/preview'
      expect(response.body)
        .to match(
          %r{<li data-maglev-block-id="block-0">\s+<h3 data-maglev-id="block-0.title">\s+My work\s+</h3>\s+<img data-maglev-id="block-0.image" src="/samples/images/default.svg" />\s+</li>}
        )
    end
    # rubocop:enable Layout/LineLength

    context 'with a missing key' do
      let(:block) do
        { id: 'block-0', type: 'item',
          settings: [{ id: 'title', value: 'My work' }, { id: 'image', value: '' }] }
      end

      # rubocop:disable Layout/LineLength
      it 'works anyway' do
        get '/maglev/preview'
        expect(response.body)
          .to match(
            %r{<li data-maglev-block-id="block-0">\s+<h3 data-maglev-id="block-0.title">\s+My work\s+</h3>\s+<img data-maglev-id="block-0.image" src="" />\s+</li>}
          )
      end
      # rubocop:enable Layout/LineLength
    end
  end

  context 'rendering a section with nested blocks (tree)' do
    let(:navbar) { site.sections.find { |section| section['type'] == 'navbar' } }
    let(:blocks) do
      [
        { id: 'block-0', type: 'menu_item', settings: [{ id: 'label', value: 'Item #0' }] },
        { id: 'block-0-0', type: 'menu_item', parent_id: 'block-0', settings: [{ id: 'label', value: 'Item #0-0' }] },
        { id: 'block-0-1', type: 'menu_item', parent_id: 'block-0', settings: [{ id: 'label', value: 'Item #0-1' }] },
        { id: 'block-1', type: 'menu_item', settings: [{ id: 'label', value: 'Item #1' }] }
      ]
    end

    before do
      navbar['blocks'] = blocks
      site.save
    end

    it 'displays the expected content' do
      get '/maglev/preview'
      expect(pretty_html(response.body))
        .to include(<<-HTML
              <nav>
                <ul>
                  <li class="navbar-item" id="block-block-0" data-maglev-block-id="block-0">
                    <a data-maglev-id="block-0.link" href="/maglev/preview">
                      <em>
                        <span data-maglev-id="block-0.label">Item #0</span>
                      </em>
                    </a>
                    <ul>
                      <li class="navbar-nested-item" id="block-block-0-0" data-maglev-block-id="block-0-0">
                        <a data-maglev-id="block-0-0.link" class="navbar-link" href="/maglev/preview">
                          <span data-maglev-id="block-0-0.label">Item #0-0</span>
                        </a>
                      </li>
                      <li class="navbar-nested-item" id="block-block-0-1" data-maglev-block-id="block-0-1">
                        <a data-maglev-id="block-0-1.link" class="navbar-link" href="/maglev/preview">
                          <span data-maglev-id="block-0-1.label">Item #0-1</span>
                        </a>
                      </li>
                    </ul>
                  </li>
                  <li class="navbar-item" id="block-block-1" data-maglev-block-id="block-1">
                    <a data-maglev-id="block-1.link" href="/maglev/preview">
                      <em>
                        <span data-maglev-id="block-1.label">Item #1</span>
                      </em>
                    </a>
                  </li>
                </ul>
              </nav>
        HTML
          .strip)
    end
  end
end
