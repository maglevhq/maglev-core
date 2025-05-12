# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::Api::CollectionItemsController', type: :request do
  let!(:site) { create(:site) }

  context 'Given the editor is not authenticated' do
    it 'returns a 401 error (unauthorized)' do
      get '/maglev/api/collections/products', params: { q: '' }, as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'Given the editor is authenticated' do
    before { api_sign_in }

    describe 'find all the items of a collection defined in the Maglev config file' do
      describe 'allows retrieval of items based on keyword' do
        it 'returns an empty array if the keyword is empty' do
          get '/maglev/api/collections/products', params: { q: '' }, as: :json
          expect(json_response).to eq([].as_json)
        end

        it 'returns the items whose label matches the keyword' do
          FactoryBot.rewind_sequences
          products = create_list(:product, 2)
          get '/maglev/api/collections/products', params: { q: '#01' }, as: :json
          expect(json_response.size).to eq 1
          expect(json_response.first.deep_symbolize_keys).to include(
            id: products[0].id,
            label: 'Product #01'
          )
          expect(json_response.first['image_url']).to match(%r{^http://example\.local/.*/asset.jpg$})
        end
      end
    end

    describe 'find the any item' do
      it 'returns a null object if there are no items in the collection' do
        get '/maglev/api/collections/products/any', as: :json
        expect(json_response).to eq(nil)
      end

      it 'returns the first item of the collection if the id is "any"' do
        FactoryBot.rewind_sequences
        products = create_list(:product, 2)
        get '/maglev/api/collections/products/any', as: :json
        expect(json_response.deep_symbolize_keys).to include(
          id: products[0].id,
          label: 'Product #01'
        )
        expect(json_response['image_url']).to match(%r{^http://example\.local/.*/asset.jpg$})
      end
    end
  end
end
