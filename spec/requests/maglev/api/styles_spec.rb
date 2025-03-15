# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::Api::StylesController', type: :request do
  let!(:site) { create(:site) }
  
  before do
    allow(Maglev::I18n).to receive(:available_locales).and_return(%i[en fr])
    Maglev.configure do |config|
      config.services = {
        context: double('Context', controller: double('Controller')),
        fetch_site: double('FetchSite', call: site),
        fetch_theme: double('FetchTheme', call: build(:theme)),
        get_base_url: double('getBaseUrl', call: '/maglev/preview'),
        generate_site: double('GenerateSite', call: site)
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

    let(:attributes) { attributes_for(:site, :with_style)[:style] }
    
    it 'updates the style of the site' do
      put '/maglev/api/style', params: { style: attributes }, as: :json
      expect(response).to have_http_status(:ok)
      expect(site.reload.style[0]['value']).to eq '#ff00ff'
    end
  end
end
