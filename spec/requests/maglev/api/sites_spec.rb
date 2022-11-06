# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::Api::SitesController', type: :request do
  let!(:site) { create(:site, :with_style) }
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
      get '/maglev/api/site', as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'Given the editor is authenticated' do
    before { api_sign_in }

    it 'allows retrieval of the current site' do
      get '/maglev/api/site', as: :json
      expect(json_response.deep_symbolize_keys).to include(
        {
          id: site.id,
          homePageId: page.id,
          locales: [{ label: 'English', prefix: 'en' }, { label: 'French', prefix: 'fr' }],
          style: [
            { id: 'primary_color', type: 'color', value: '#ff00ff' },
            { id: 'font_name', type: 'text', value: 'roboto' }
          ]
        }
      )
    end
  end
end
