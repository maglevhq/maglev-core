# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::PagePreviewController', type: :request do
  let(:theme) { build(:theme, :predefined_pages) }
  let!(:site) { Maglev::GenerateSite.call(theme: theme) }
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

    context 'with scoped site sections' do
      let(:header_sections) { attributes_for(:sections_content_store, :header)[:sections] }
      before do
        Maglev::SectionsContentStore.find_by(handle: 'header').update!(sections: header_sections)
        # the navbar must also be persisted in the site scoped sections content store
        Maglev::SectionsContentStore.find_by(handle: '_site').update!(sections: header_sections)        
      end

      it 'renders the index page with the navbar' do
        get '/maglev/preview'
        expect(response.body).to include('<title>Default - Home</title>')
        expect(response.body).to include('<span data-maglev-id="menu-item-1.label">About us</span>')
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
      page = create(:page, title: 'Contact us', path: 'contact')
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
    let(:section_id) { fetch_sections_content('main', home_page.id).dig(0, 'id') }

    it 'renders the index page with the content from the params' do
      post '/maglev/preview', params: { section_id: section_id }
      expect(response.body).to match(%r{<h1 data-maglev-id="\S+\.title" class="[^>]+">Let's create the product<br/>your clients<br/>will love.</h1>})
    end
  end

  context 'rendering a section with blocks' do
    let(:store) { Maglev::SectionsContentStore.find_by(handle: 'main', page: home_page) }
    let(:showcase) { store.find_section_by_type('showcase') }
    let(:block) do
      { id: 'block-0', type: 'item',
        settings: [{ id: 'title', value: 'My work' }, { id: 'image', value: '/samples/images/default.svg' }] }
    end

    before do
      showcase['blocks'] << block
      store.save
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
    let(:site_store) { Maglev::SectionsContentStore.find_by(handle: '_site') }
    let(:navbar) { site_store.find_section_by_type('navbar') }
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
      site_store.save
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
