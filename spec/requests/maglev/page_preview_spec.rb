# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::PagePreview', type: :request do
  let!(:site) { Maglev::GenerateSite.call }

  context 'normal rendering' do
    it 'renders the index page' do
      get '/maglev/preview'
      expect(response.body).to include('<title>default</title>')
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
        get "/maglev/preview"
        expect(response.body).to include('<title>default</title>')
        expect(response.body).to include('<a href="https://www.nocoffee.fr" target="_blank">')
      end
    end
  end

  context 'rendering from POST params' do
    let(:sections) do
      Maglev::Page.first.sections.tap do |sections|
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
      get "/maglev/preview"
      expect(response.body)
        .to include(
          '<li data-maglev-block-id="block-0"><h3 data-maglev-id="block-0.title">My work</h3><img src="/samples/images/default.svg" alt="My work" /></li>'
        )
    end

    context 'with a missing key' do
      let(:block) do
        { id: 'block-0', type: 'item', settings: [{ id: 'title', value: 'My work' }] }
      end

      it 'works anyway' do
        get "/maglev/preview"
        expect(response.body)
          .to include('<li data-maglev-block-id="block-0"><h3 data-maglev-id="block-0.title">My work</h3><img src="" alt="My work" /></li>')
      end
    end
  end
end
