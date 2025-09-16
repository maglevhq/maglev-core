# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::Editor::Combobox::PagesController, type: :request do
  let(:theme) { build(:theme, :predefined_pages) }
  let!(:site) { Maglev::GenerateSite.call(theme: theme) }
  let!(:home_page) { Maglev::Page.home.first }

  describe 'GET #index' do
    it 'returns no pages' do
      get '/maglev/editor/combobox/pages', as: :turbo_stream, params: { query: 'random' }
      expect(response).to be_successful
      expect(response.headers['X-Select-Options-Size']).to eq(0)
    end

    it 'returns the filtered pages' do
      get '/maglev/editor/combobox/pages', as: :turbo_stream, params: { query: 'Home' }
      expect(response).to be_successful
      expect(response.body).to include('Home')
      expect(response.headers['X-Select-Options-Size']).to eq(1)
    end
  end
end