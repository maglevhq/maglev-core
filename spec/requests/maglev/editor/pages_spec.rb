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

  describe 'GET /maglev/editor/:context/pages/:id/edit' do
    it 'returns a success response' do
      get "/maglev/editor/en/#{home_page.id}/pages/#{home_page.id}/edit"
      expect(response).to be_successful
    end
  end
end
