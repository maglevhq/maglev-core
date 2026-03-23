# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::Assets::ActiveStorageProxyController do
  routes { Maglev::Engine.routes }

  describe 'GET show' do
    describe 'Given we use uuids as primary keys in the DB' do
      before do
        allow(Maglev).to receive(:uuid_as_primary_key?).and_return(true)
      end

      it 'serves the file' do
        asset = create(:asset)
        expect(Maglev::Asset).to receive(:find).with('9565604d-be66-4a23-98da-ed1639804103').and_return(asset)
        get :show, params: { id: '9565604d-be66-4a23-98da-ed1639804103-myasset' }
      end
    end

    context 'when the asset is an SVG' do
      it 'responds with Content-Type image/svg+xml' do
        svg_asset = create(:asset, :svg)
        get :show, params: { id: svg_asset.id, filename: 'logo.svg' }

        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq('image/svg+xml')
      end
    end
  end
end
