# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'live-preview-client.js', type: :request do
  describe 'GET /maglev/live-preview-client.js' do
    it 'serves the JS file' do
      get '/maglev/live-preview-client.js'
      expect(response.headers['Location']).to include('http://www.example.com/maglev-assets-test/assets/live-preview-rails-client')
    end
  end
end
