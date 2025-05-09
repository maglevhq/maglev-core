# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::Assets::ActiveStorageProxyController' do
  let(:asset) { create(:asset) }

  it 'allows retrieval by id' do
    get "/simple-assets/#{asset.id}"
    expect(response.body).to eq(IO.binread(file_fixture('asset.jpg')))
    expect(response.headers['cache-control']).to eq('max-age=3600, public')
  end
end
