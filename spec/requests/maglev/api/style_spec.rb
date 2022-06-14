# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::API::StyleController', type: :request do
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
      put '/maglev/api/style', as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'Given the editor is authenticated' do
    before { api_sign_in }
    it 'allows to change the style of the current site' do
      expect do
        put '/maglev/api/style', params: { site: { style: [{ id: 'primary_color', type: 'color', value: '#00F' }] } },
                                 as: :json
      end.to change { site.reload.style[0]['value'] }.to('#00F')
      expect(response).to have_http_status(:ok)
    end
  end
end
