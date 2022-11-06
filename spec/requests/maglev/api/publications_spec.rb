# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::Api::PublicationsController', type: :request do
  let!(:site) { create(:site) }
  let!(:page) { create(:page) }

  before do
    Maglev.configure do |config|
      config.services = {
        context: double('Context', controller: double('Controller')),
        fetch_site: double('FetchSite', call: site),
        fetch_theme: double('FetchTheme', call: build(:theme)),
        get_base_url: double('GetBaseUrl', call: '/maglev/preview')
      }
    end
  end

  context 'Given the editor is not authenticated' do
    it 'returns a 401 error (unauthorized)' do
      get '/maglev/api/publication', as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'Given the editor is authenticated' do
    before { api_sign_in }

    it 'returns an exception' do
      expect do
        get '/maglev/api/publication', as: :json
      end.to raise_error 'NOT IMPLEMENTED'
    end
  end
end
