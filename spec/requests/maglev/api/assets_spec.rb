# frozen_string_literal: true

require 'rails_helper'
require 'open-uri'

RSpec.describe 'Maglev::Api::AssetsController', type: :request do
  before { create(:site) }

  context 'Given the editor is not authenticated' do
    it 'returns a 401 error (unauthorized)' do
      get '/maglev/api/assets', as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'Given the editor is authenticated' do
    before { api_sign_in }

    describe 'with existing assets' do
      let!(:asset) { create(:asset) }

      it 'allows retrieval of them' do
        get '/maglev/api/assets', as: :json

        expect(json_response['data']).to match(
          [
            hash_including({
              id: asset.id,
              width: 800,
              height: 375,
              byte_size: 104_016,
              url: maglev.public_asset_url(asset, only_path: true)
            }.as_json)
          ]
        )

        expect(json_response['data'][0]).to have_key('url')
      end

      it 'paginates them' do
        create_list(:asset, 25)

        get '/maglev/api/assets', as: :json
        expect(json_response).to match(
          hash_including({
            total_pages: 3,
            total_items: 26,
            next: maglev.api_assets_path(page: 2)
          }.as_json)
        )
      end

      it 'allows deleting them' do
        expect do
          delete "/maglev/api/assets/#{asset.id}"
        end.to change(::Maglev::Asset, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end

      it 'fails when deleting missing assets' do
        delete '/maglev/api/assets/made-up-id'
        expect(response).to have_http_status(:not_found)
      end
    end

    describe 'uploads' do
      let(:params) do
        {
          asset: {
            file: fixture_file_upload('asset.jpg', 'image/jpeg', true)
          }
        }
      end

      it 'work as expected' do
        expect do
          post '/maglev/api/assets', params: params
        end.to change(Maglev::Asset, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(response.location).to eq(maglev.api_asset_path(Maglev::Asset.first))
      end

      it 'returns errors if asset is missing' do
        post '/maglev/api/assets'
        expect(json_response['errors'].size).to eq(1)
        expect(json_response['errors'].first).to eq('param is missing or the value is empty: asset')
          .or eq('param is missing or the value is empty or invalid: asset')
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
