# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::PagePreviewController', type: :request do
  let(:theme) { build(:theme, :predefined_pages) }
  let!(:site) do
    Maglev::GenerateSite.call(theme: theme)
  end

  context 'normal rendering' do
    it 'renders the index page' do
      get '/maglev/preview'
      expect(response.body).to include('<title>Default</title>')
      expect(response.body).to match(%r{<h1 data-maglev-id="\S+\.title" class="display-3">Let's create the product<br/>your clients<br/>will love\.</h1>})
      expect(response.body).to include('Our projects')
    end

    context 'with scoped site sections' do
      before do
        Maglev::Page.first.update!(
          sections: attributes_for(:page, :with_navbar)[:sections]
        )
        site.update!(
          sections: attributes_for(:site, :with_navbar)[:sections]
        )
      end

      it 'renders the index page with the navbar' do
        get '/maglev/preview'
        expect(response.body).to include('<title>Default</title>')
        expect(response.body).to include('<a data-maglev-id="zzz.link" target="_blank" href="https://www.nocoffee.fr">')
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

  context 'rendering from POST params' do
    let(:sections) do
      Maglev::Page.all.order(title: :desc)[1].sections.tap do |sections|
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

    it 'displays the expected content' do
      get '/maglev/preview'
      expect(response.body)
        .to match(
          %r{<li data-maglev-block-id="block-0">\s+<h3 data-maglev-id="block-0.title">\s+My work\s+</h3>\s+<img data-maglev-id="block-0.image" src="/samples/images/default.svg" />\s+</li>}
        )
    end

    context 'with a missing key' do
      let(:block) do
        { id: 'block-0', type: 'item',
          settings: [{ id: 'title', value: 'My work' }, { id: 'image', value: '' }] }
      end

      it 'works anyway' do
        get '/maglev/preview'
        expect(response.body)
          .to match(
            %r{<li data-maglev-block-id="block-0">\s+<h3 data-maglev-id="block-0.title">\s+My work\s+</h3>\s+<img data-maglev-id="block-0.image" src="" />\s+</li>}
          )
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
      expect(pretty_html(response.body))
        .to include(<<-HTML
        <nav>
          <ul>
            <li class="navbar-item" data-maglev-block-id="block-0">
              <a data-maglev-id="block-0.link" href="/maglev/preview">
                <span data-maglev-id="block-0.label">Item #0</span>
              </a>
              <ul>
                <li class="navbar-nested-item" data-maglev-block-id="block-0-0">
                  <a data-maglev-id="block-0-0.link" href="/maglev/preview">
                    <span data-maglev-id="block-0-0.label">Item #0-0</span>
                  </a>
                </li>
                <li class="navbar-nested-item" data-maglev-block-id="block-0-1">
                  <a data-maglev-id="block-0-1.link" href="/maglev/preview">
                    <span data-maglev-id="block-0-1.label">Item #0-1</span>
                  </a>
                </li>
              </ul>
            </li>
            <li class="navbar-item" data-maglev-block-id="block-1">
              <a data-maglev-id="block-1.link" href="/maglev/preview">
                <span data-maglev-id="block-1.label">Item #1</span>
              </a>
            </li>
          </ul>
        </nav>
        HTML
          .strip)
    end
  end
end
