# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::Editor::Combobox::CollectionItemsController, type: :request do
  let(:theme) { build(:theme, :predefined_pages) }
  let!(:site) { Maglev::GenerateSite.call(theme: theme) }

  before do
    create_list(:product, 4, :without_thumbnail)
  end

  describe 'GET #index' do
    it 'returns no items' do
      get '/maglev/editor/combobox/collection_items', as: :turbo_stream,
                                                      params: { collection_id: 'products', query: 'random' }
      expect(response).to be_successful
      expect(response.headers['X-Select-Options-Size']).to eq(0)
    end
  end

  describe 'GET #index' do
    it 'returns the filtered items' do
      get '/maglev/editor/combobox/collection_items', as: :turbo_stream,
                                                      params: { collection_id: 'products', query: 'Product' }
      expect(response).to be_successful
      expect(response.headers['X-Select-Options-Size']).to eq(4)
    end
  end
end
