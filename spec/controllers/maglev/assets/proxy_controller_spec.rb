# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::Assets::ProxyController do
  module Maglev::FakeStorage; end

  before(:all) do
    @original_uploader = Maglev.config.uploader
    Maglev.configure do |config|
      config.uploader = :fake_storage # or whatever value makes it use the proxy controller
    end
  end

  after(:all) do
    Maglev.configure do |config|
      config.uploader = @original_uploader
    end
  end

  routes { Maglev::Engine.routes }

  describe 'GET show' do
    describe 'Given we use uuids as primary keys in the DB' do
      before do
        allow(Maglev).to receive(:uuid_as_primary_key?).and_return(true)
      end

      it 'serves the file' do
        asset = double('Maglev::Asset')
        expect(Maglev::Asset).to receive(:find).with('9565604d-be66-4a23-98da-ed1639804103').and_return(asset)
        expect(asset).to receive(:download).and_return('file content')
        expect(asset).to receive(:filename).and_return('test.jpg')
        expect(asset).to receive(:content_type).and_return('image/jpeg')

        get :show, params: { id: '9565604d-be66-4a23-98da-ed1639804103-myasset' }

        expect(response.headers['Content-Type']).to eq 'image/jpeg'
        expect(response.body).to eq 'file content'
      end
    end
  end
end
