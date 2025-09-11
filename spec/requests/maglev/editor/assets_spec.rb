# frozen_string_literal: true

require 'rails_helper'

describe 'Maglev::Editor::Assets', type: :request do
  let(:theme) { build(:theme, :predefined_pages) }
  let!(:site) { Maglev::GenerateSite.call(theme: theme) }
  let!(:home_page) { Maglev::Page.home.first }

  describe 'GET /maglev/editor/assets' do
    describe 'Not requesting a turbo frame' do
      it 'returns a redirect response' do
        get '/maglev/editor/assets'
        expect(response).to redirect_to('/maglev/editor')
      end
    end

    describe 'Requesting a turbo frame' do
      it 'returns a success response' do
        get '/maglev/editor/assets', headers: { "Turbo-Frame": 'modal' }
        expect(response).to be_successful
      end

      describe 'Pagination' do
        before { create_list(:asset, 18, :small) }

        it 'returns a success response' do
          get '/maglev/editor/assets', headers: { "Turbo-Frame": 'modal' }
          expect(response).to be_successful
          expect(response.body).to include('Displaying items 1-16 of 18 in total')
        end
      end
    end

    describe 'POST /maglev/editor/assets' do
      it 'returns a success response' do
        expect do
          post '/maglev/editor/assets',
               params: { asset: { file: fixture_file_upload('spec/fixtures/files/asset.jpg', 'image/jpeg') } }
          expect(response).to be_created
        end.to change(Maglev::Asset, :count).by(1)
      end
    end

    describe 'DELETE /maglev/editor/assets/:id' do
      let(:asset) { create(:asset, :small) }

      it 'returns a success response' do
        delete "/maglev/editor/assets/#{asset.id}"
        expect(response).to redirect_to('/maglev/editor/assets')
      end
    end
  end
end
