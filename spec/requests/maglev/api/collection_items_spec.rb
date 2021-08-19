# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::API::CollectionItemsController', type: :request do
  let!(:site) { create(:site) }

  describe 'find all the items of a collection defined in the Maglev config file' do

    describe 'allows retrieval of items based on keyword' do
      it 'returns an empty array if the keyword is empty' do
        get '/maglev/api/collections/products', params: { q: '' }, as: :json
        expect(json_response).to eq([].as_json)
      end

      it 'returns the items whose label matches the keyword' do
        products = create_list(:product, 2)
        get '/maglev/api/collections/products', params: { q: '#1' }, as: :json
        expect(json_response.size).to eq 1
        expect(json_response.first.deep_symbolize_keys).to include(
          id: products[0].id,
          label: 'Product #1',
        )
        expect(json_response.first['image_url']).to match(/^http:\/\/example\.local\/.*\/asset.jpg$/)
      end
    end   
  end
end