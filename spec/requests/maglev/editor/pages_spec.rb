# frozen_string_literal: true

require 'rails_helper'

describe 'Maglev::Editor::Pages', type: :request do
  let(:theme) { build(:theme, :predefined_pages) }
  let!(:site) { Maglev::GenerateSite.call(theme: theme) }
  let!(:home_page) { Maglev::Page.home.first }

  describe 'GET /maglev/editor/:context/pages' do
    it 'returns a success response' do
      get "/maglev/editor/en/#{home_page.id}/pages"
      expect(response).to be_successful
    end
  end

  describe 'GET /maglev/editor/:context/pages/new' do
    it 'returns a success response' do
      get "/maglev/editor/en/#{home_page.id}/pages/new"
      expect(response).to be_successful
    end
  end

  describe 'POST /maglev/editor/:context/pages' do
    it 'returns a redirect response' do
      expect do
        post "/maglev/editor/en/#{home_page.id}/pages", params: { page: { title: 'Test Page', path: 'test-page' } }
        expect(response).to be_redirect
      end.to change(Maglev::Page, :count).by(1)
    end
  end

  describe 'GET /maglev/editor/:context/pages/:id/edit' do
    it 'returns a success response' do
      get "/maglev/editor/en/#{home_page.id}/pages/#{home_page.id}/edit"
      expect(response).to be_successful
    end
  end

  describe 'PUT /maglev/editor/:context/pages/:id' do
    it 'returns a redirect response' do
      put "/maglev/editor/en/#{home_page.id}/pages/#{home_page.id}", params: { page: { title: 'Home page [UPDATED]' } }
      expect(response.status).to eq(303)
      expect(home_page.reload.title).to eq('Home page [UPDATED]')
    end
  end

  describe 'DELETE /maglev/editor/:context/pages/:id' do
    let!(:page) { create(:page, path: 'test-page') }
    it 'returns a redirect response' do
      expect do
        delete "/maglev/editor/en/#{home_page.id}/pages/#{page.id}"
        expect(response).to be_redirect
      end.to change(Maglev::Page, :count).by(-1)
    end
  end
end
