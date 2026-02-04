# frozen_string_literal: true

require 'rails_helper'

describe 'Maglev::Editor::Sections', type: :request do
  let(:theme) { build(:theme, :predefined_pages) }
  let!(:site) { Maglev::GenerateSite.call(theme: theme) }
  let!(:home_page) { Maglev::Page.home.first }

  describe 'GET /maglev/editor/:context/:store_id/sections/new' do
    it 'returns a success response' do
      get "/maglev/editor/en/#{home_page.id}/main/sections/new"
      expect(response.body).to have_selector('h2[data-editor-page-layout-title]', text: 'Add a section')
      expect(response).to be_successful
    end
  end

  describe 'POST /maglev/editor/:context/:store_id/sections' do
    let(:theme) { build(:theme) }
    let(:home_page) { create(:page, sections: nil) }
    let!(:sections_store) { create(:sections_content_store, :empty, page: home_page) }
    let(:section_type) { 'jumbotron' }

    it 'returns a success response' do
      expect do
        post "/maglev/editor/en/#{home_page.id}/main/sections", params: { section_type: section_type, position: 0 }
        section_id = sections_store.reload.sections.dig(0, 'id')
        expect(response).to redirect_to("/maglev/editor/en/#{home_page.id}/sections/#{section_id}/edit")
        expect(flash[:store_id]).to eq('main')
        expect(flash[:section_id]).not_to be_nil
        expect(flash[:position]).to eq(0)
      end.to change { sections_store.reload.sections.count }.by(1)
    end
  end

  describe 'GET /maglev/editor/:context/sections/:id/edit' do
    let(:main_store) { fetch_sections_store('main', home_page.id) }
    let(:section_id) { main_store.sections.dig(0, 'id') }

    it 'returns a success response' do
      get "/maglev/editor/en/#{home_page.id}/sections/#{section_id}/edit"
      expect(response.body).to have_selector('h2[data-editor-page-layout-title]', text: 'Jumbotron')
      expect(response.body).to have_selector('label[for=section_title]', text: 'Title')
      expect(response.body).to have_selector('label[for=section_body]', text: 'Body')
    end

    describe "when the section doesn't exist anymore" do
      it 'returns a 404 response' do
        get "/maglev/editor/en/#{home_page.id}/sections/not_existing/edit"
        expect(response).to redirect_to("/maglev/editor/en/#{home_page.id}/sections")
      end
    end
  end

  describe 'PUT /maglev/editor/:context/sections/:id' do
    let(:main_store) { fetch_sections_store('main', home_page.id) }
    let(:section_id) { main_store.sections.dig(0, 'id') }

    it 'returns a success response' do
      put "/maglev/editor/en/#{home_page.id}/sections/#{section_id}",
          as: :turbo_stream,
          params: { section: { title: 'Hello world!' } },
          headers: { "Turbo-Frame": '_top' }
      expect(response).to be_successful
      expect(response.media_type).to eq Mime[:turbo_stream]
      expect(main_store.reload.sections.dig(0, 'settings', 0, 'value')).to eq('Hello world!')
    end
  end

  describe 'DELETE /maglev/editor/:context/sections/:id' do
    let(:main_store) { fetch_sections_store('main', home_page.id) }
    let(:section_id) { main_store.sections.dig(0, 'id') }

    it 'returns a success response' do
      expect do
        delete "/maglev/editor/en/#{home_page.id}/sections/#{section_id}",
               headers: { "Turbo-Frame": '_top' }
        expect(response).to redirect_to("/maglev/editor/en/#{home_page.id}/sections")
      end.to change { main_store.reload.sections.count }.by(-1)
    end
  end

  describe 'PUT /maglev/editor/:context/sections/:store_id/sort' do
    let(:main_store) { fetch_sections_store('main', home_page.id) }

    it 'returns a success response' do
      original_section_ids = main_store.section_ids
      expect do
        put "/maglev/editor/en/#{home_page.id}/main/sections/sort",
            params: { item_ids: original_section_ids.reverse, lock_version: main_store.lock_version }
        expect(response).to redirect_to("/maglev/editor/en/#{home_page.id}/sections")
      end.to change { main_store.reload.section_ids }.to(original_section_ids.reverse)
    end
  end
end
