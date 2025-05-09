# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::Assets::ActiveStorageProxyController' do
  let(:asset) { create(:asset) }

  it 'allows retrieval by id' do
    get "/maglev/assets/#{asset.id}/gibberish"
    expect(response.body).to eq(IO.binread(file_fixture('asset.jpg')))
    expect(response.headers['cache-control']).to match('max-age=3155695200, public')
  end
end
