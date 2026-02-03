# frozen_string_literal: true

require 'rails_helper'

describe 'Maglev::Editor::Sections', type: :request do
  let(:theme) { build(:theme, :predefined_pages) }
  let!(:site) { Maglev::GenerateSite.call(theme: theme) }
  let!(:home_page) { Maglev::Page.home.first }

  describe 'GET /maglev/editor/:context/sections' do
    it 'returns a success response' do
      get "/maglev/editor/en/#{home_page.id}/sections"
      expect(response).to be_successful
    end
  end

  describe 'GET /maglev/editor/:context/sections/new' do
    it 'returns a success response' do
      get "/maglev/editor/en/#{home_page.id}/sections/new"
      expect(response.body).to have_selector('h2[data-editor-page-layout-title]', text: 'Add a section')
      expect(response).to be_successful
    end
  end

  describe 'POST /maglev/editor/:context/sections' do
    let(:theme) { build(:theme) }
    let!(:home_page) { create(:page, sections: []) }
    let(:section_type) { 'jumbotron' }
    it 'returns a success response' do
      expect do
        post "/maglev/editor/en/#{home_page.id}/sections", params: { section_type: section_type, position: 0 }
        section_id = home_page.reload.sections.dig(0, 'id')
        expect(response).to redirect_to("/maglev/editor/en/#{home_page.id}/sections/#{section_id}/edit")
        expect(flash[:section_id]).not_to be_nil
        expect(flash[:position]).to eq(0)
      end.to change { home_page.reload.sections.count }.by(1)
    end

    describe 'Give the section definition defines a position (insert_at: top)' do
      let(:section_type) { 'navbar' }
      before do
        home_page.update(sections_translations: build(:page).sections_translations)
      end
      it 'adds the section to the top of the page' do
        expect do
          post "/maglev/editor/en/#{home_page.id}/sections", params: { section_type: section_type, position: 2 }
          expect(flash[:position]).to eq(0)
        end.to change { home_page.reload.sections.count }.by(1)
      end
    end
  end

  describe 'GET /maglev/editor/:context/sections/:id/edit' do
    it 'returns a success response' do
      get "/maglev/editor/en/#{home_page.id}/sections/#{home_page.sections.dig(1, 'id')}/edit"
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
    it 'returns a success response' do
      put "/maglev/editor/en/#{home_page.id}/sections/#{home_page.sections.dig(1, 'id')}",
          as: :turbo_stream,
          params: { section: { title: 'Hello world!' } },
          headers: { "Turbo-Frame": '_top' }
      expect(response).to be_successful
      expect(response.media_type).to eq Mime[:turbo_stream]
      expect(home_page.reload.sections.dig(1, 'settings', 0, 'value')).to eq('Hello world!')
    end
  end

  describe 'DELETE /maglev/editor/:context/sections/:id' do
    it 'returns a success response' do
      expect do
        delete "/maglev/editor/en/#{home_page.id}/sections/#{home_page.sections.dig(1, 'id')}",
               headers: { "Turbo-Frame": '_top' }
        expect(response).to redirect_to("/maglev/editor/en/#{home_page.id}/sections")
      end.to change { home_page.reload.sections.count }.by(-1)
    end
  end

  describe 'POST /maglev/editor/:context/sections/sort' do
    it 'returns a success response' do
      original_section_ids = home_page.section_ids
      expect do
        put "/maglev/editor/en/#{home_page.id}/sections/sort",
            params: { item_ids: original_section_ids.reverse, lock_version: home_page.lock_version }
        expect(response).to redirect_to("/maglev/editor/en/#{home_page.id}/sections")
      end.to change { home_page.reload.section_ids }.to(original_section_ids.reverse)
    end
  end
end
