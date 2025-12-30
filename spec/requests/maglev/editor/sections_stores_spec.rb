# frozen_string_literal: true

require 'rails_helper'

describe 'Maglev::Editor::SectionsStores', type: :request do
  let(:theme) { build(:theme, :predefined_pages) }
  let!(:site) { Maglev::GenerateSite.call(theme: theme) }
  let!(:home_page) { Maglev::Page.home.first }

  describe 'GET /maglev/editor/:context/sections' do
    it 'returns a success response' do
      get "/maglev/editor/en/#{home_page.id}/sections"
      expect(response).to be_successful
    end
  end
end