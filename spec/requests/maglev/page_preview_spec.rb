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
      expect(response.body).to match(%r{<h1 data-maglev-id="\S+\.title" class="[^>]+">Let's create the product<br/>your clients<br/>will love\.</h1>})
      expect(response.body).to include('Our projects')
    end
    # rubocop:enable Layout/LineLength

    # context 'live site' do
    #   it 'renders the index page in the default locale' do
    #     get '/'
    #     expect(response.body).to include('<title>Default - Home</title>')
    #     expect(response.body).to include('<meta name="hello" content="Hello world" />')
    #     expect(response.body).to include('<link rel="alternate" hreflang="x-default" href="http://www.example.com">')
    #     expect(response.body).to include('<link rel="alternate" hreflang="en" href="http://www.example.com">')
    #     expect(response.body).to include('<link rel="alternate" hreflang="fr" href="http://www.example.com/fr">')
    #   end

    #   it 'renders the site the custom style' do
    #     get '/'
    #     expect(response.body).to include('--basic-theme-primary-color: #F87171;')
    #   end

    #   describe 'Given Facebook/Google/Twitter/LinkedIn crawl the index page' do
    #
    #     let(:headers) { { 'HTTP_CONTENT_TYPE' => '*/*', 'HTTP_ACCEPT' => '*/*', 'HTTP_USER_AGENT' => user_agent } }
    #         #     describe 'Given Facebook crawls it' do
    #       let(:user_agent) { 'facebookexternalhit/1.1' }
    #       it 'renders the index page' do
    #         get '/index', headers: headers
    #         expect(response.body).to include('<title>Default - Home</title>')
    #       end
    #     end

    #     describe 'Given Twitter crawls it' do
    #       let(:user_agent) { 'Twitterbot' }
    #       it 'renders the index page' do
    #         get '/index', headers: headers
    #         expect(response.body).to include('<title>Default - Home</title>')
    #       end
    #     end

    #     describe 'Given Google crawls it' do
    #       let(:user_agent) { 'Googlebot/2.1' }
    #       it 'renders the index page' do
    #         get '/index', headers: headers
    #         expect(response.body).to include('<title>Default - Home</title>')
    #       end
    #     end

    #     describe 'Given LinkedIn crawls it' do
    #       let(:user_agent) { 'LinkedInBot/1.0' }
    #       it 'renders the index page' do
    #         get '/index', headers: headers
    #         expect(response.body).to include('<title>Default - Home</title>')
    #       end
    #     end
    #   end
    # end

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

    before { home_page.update(sections: sections) }

    it 'renders the index page with the content from the params' do
      post '/maglev/preview', params: { section_id: sections.dig(0, 'id') }
      expect(response.body).to match(%r{<h1 data-maglev-id="\S+\.title" class="[^>]+">UPDATED TITLE</h1>})
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

    it 'displays the expected content' do
      get '/maglev/preview'

      doc = parse_html(response.body)
      block_item = expect_element_present(doc, 'li[data-maglev-block-id="block-0"]')

      title_element = expect_element_present(block_item, 'h3[data-maglev-id="block-0.title"]')
      expect_element_text(title_element, 'My work')

      image_element = expect_element_present(block_item, 'img[data-maglev-id="block-0.image"]')
      expect_element_attributes(image_element, { src: '/samples/images/default.svg' })
    end

    context 'with a missing key' do
      let(:block) do
        { id: 'block-0', type: 'item',
          settings: [{ id: 'title', value: 'My work' }, { id: 'image', value: '' }] }
      end

      it 'works anyway' do
        get '/maglev/preview'

        doc = parse_html(response.body)
        block_item = expect_element_present(doc, 'li[data-maglev-block-id="block-0"]')

        title_element = expect_element_present(block_item, 'h3[data-maglev-id="block-0.title"]')
        expect_element_text(title_element, 'My work')

        image_element = expect_element_present(block_item, 'img[data-maglev-id="block-0.image"]')
        expect_element_attributes(image_element, { src: '' })
      end
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

      doc = Nokogiri::HTML(response.body)
      nav = doc.at_css('nav')

      expect(nav).to be_present

      # Check the main navigation structure
      navbar_items = nav.css('.navbar-item')
      expect(navbar_items.length).to eq(2)

      # Check first item with nested children
      first_item = navbar_items.first
      expect(first_item['data-maglev-block-id']).to eq('block-0')
      expect(first_item['id']).to eq('block-block-0')

      first_link = first_item.at_css('a[data-maglev-id="block-0.link"]')
      expect(first_link['href']).to eq('#')
      expect(first_link.at_css('span[data-maglev-id="block-0.label"]').text.strip).to eq('Item #0')

      # Check nested items
      nested_items = first_item.css('.navbar-nested-item')
      expect(nested_items.length).to eq(2)

      expect(nested_items[0]['data-maglev-block-id']).to eq('block-0-0')
      expect(nested_items[0]['id']).to eq('block-block-0-0')
      expect(nested_items[0].at_css('span[data-maglev-id="block-0-0.label"]').text.strip).to eq('Item #0-0')

      expect(nested_items[1]['data-maglev-block-id']).to eq('block-0-1')
      expect(nested_items[1]['id']).to eq('block-block-0-1')
      expect(nested_items[1].at_css('span[data-maglev-id="block-0-1.label"]').text.strip).to eq('Item #0-1')

      # Check second item (no nested children)
      second_item = navbar_items.last
      expect(second_item['data-maglev-block-id']).to eq('block-1')
      expect(second_item['id']).to eq('block-block-1')
      expect(second_item.at_css('span[data-maglev-id="block-1.label"]').text.strip).to eq('Item #1')
    end
  end
end
