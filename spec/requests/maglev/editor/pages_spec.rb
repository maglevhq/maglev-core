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

    describe 'Pagination' do
      before do
        Maglev.config.pagination = { pages: 10, assets: 16 }
        15.times { |i| create(:page, path: "test-page-#{i}") }
      end

      after do
        Maglev.config.pagination = {}
      end

      it 'paginates pages when enabled' do
        get "/maglev/editor/en/#{home_page.id}/pages"
        expect(response).to be_successful
        expect(response.body).to include('Displaying items 1-10 of')
      end

      it 'preserves pagination params in query' do
        get "/maglev/editor/en/#{home_page.id}/pages", params: { page: 2 }
        expect(response).to be_successful
        expect(response.body).to include('Displaying items 11-')
      end

      it 'preserves search query with pagination' do
        get "/maglev/editor/en/#{home_page.id}/pages", params: { q: 'test', page: 1 }
        expect(response).to be_successful
      end
    end

    describe 'Pagination disabled' do
      before do
        Maglev.config.pagination = { pages: -1, assets: 16 }
        15.times { |i| create(:page, path: "test-page-disabled-#{i}") }
      end

      after do
        Maglev.config.pagination = {}
      end

      it 'does not paginate when limit is -1' do
        get "/maglev/editor/en/#{home_page.id}/pages"
        expect(response).to be_successful
        expect(response.body).not_to include('Displaying items')
      end
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
        post "/maglev/editor/en/#{home_page.id}/pages", params: { page: { title: 'Test Page', path: 'test-page', layout_id: 'default' } }
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
