# frozen_string_literal: true

require 'rails_helper'

describe 'Maglev::Editor::SectionMirroredStores', type: :request do
  let(:theme) { build(:theme, :predefined_pages) }
  let!(:site) { Maglev::GenerateSite.call(theme: theme) }
  let!(:home_page) { Maglev::Page.home.first }

  describe 'GET /maglev/editor/:context/:store_id/mirrored_sections/new' do
    it 'returns a success response' do
      get "/maglev/editor/en/#{home_page.id}/main/mirrored_sections/new", headers: { "Turbo-Frame": 'modal' }
      expect(response).to be_successful
    end
  end

  describe 'POST /maglev/editor/:context/:store_id/mirrored_sections' do
    let(:another_page) { create(:page, sections: nil, title: 'Another page', path: 'another-page') }
    let(:main_store) { fetch_sections_store('main', home_page.id) }
    let(:section_id) { main_store.find_section_by_type('jumbotron')['id'] }

    it 'returns a success response' do
      post "/maglev/editor/en/#{another_page.id}/main/mirrored_sections", params: {
        mirrored_section: { page_id: home_page.id, section_id: "main/jumbotron/#{section_id}" }
      }, headers: { "Turbo-Frame": 'modal', accept: 'text/vnd.turbo-stream.html' }
      expect(response).to be_successful
      expect(fetch_sections_content('main', another_page.id).dig(0, 'mirror_of', 'enabled')).to eq true
    end

    context 'refreshing the form' do
      it 'returns a success response' do
        post "/maglev/editor/en/#{another_page.id}/main/mirrored_sections", params: {
          mirrored_section: { page_id: home_page.id }, refresh: '1'
        }, headers: { "Turbo-Frame": 'modal' }
        expect(response).to be_unprocessable
        expect(response.body).to include(<<-HTML.strip_heredoc
          <option value="main/jumbotron/#{section_id}">Jumbotron</option>
        HTML
                                        )
      end
    end
  end

  describe 'DELETE /maglev/editor/:context/:store_id/mirrored_sections/:id' do
    let(:main_store) { fetch_sections_store('main', home_page.id) }
    let(:another_page) { create(:page, sections: nil, title: 'Another page', path: 'another-page') }
    let(:another_main_store) { create(:sections_content_store, page: another_page, sections: []) }
    let(:section_id) { main_store.find_section_by_type('jumbotron')['id'] }

    before do
      another_main_store.sections << {
        id: section_id,
        type: 'jumbotron',
        mirror_of: { enabled: true, page_id: home_page.id, layout_store_id: 'main', section_id: section_id }
      }
      another_main_store.save!
    end

    it 'returns a success response' do
      delete "/maglev/editor/en/#{another_page.id}/main/mirrored_sections/#{section_id}",
             headers: { "Turbo-Frame": 'modal' }
      expect(response).to be_redirect
    end
  end
end
