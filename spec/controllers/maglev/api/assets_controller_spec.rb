# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::Api::AssetsController do
  routes { Maglev::Engine.routes }

  let(:site) { build(:site) }

  before do
    allow(controller).to receive(:maglev_site).and_return(site)
  end

  describe 'GET show' do
    describe 'Given we use uuids as primary keys in the DB' do
      before do
        allow(Maglev).to receive(:uuid_as_primary_key?).and_return(true)
      end

      it 'serves the file' do
        asset = create(:asset)
        expect(Maglev::Asset).to receive(:find).with('9565604d-be66-4a23-98da-ed1639804103').and_return(asset)
        get :show, params: { id: '9565604d-be66-4a23-98da-ed1639804103-myasset', format: 'application/json' }
        expect(response.status).to eq 200
      end
    end
  end
end
