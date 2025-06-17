# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::Api::PageClonesController', type: :request do
  let(:site) { create(:site) }
  let!(:page) { create(:page) }

  before do
    Maglev.configure do |config|
      config.services = {
        context: double('Context', controller: double('Controller')),
        fetch_site: double('FetchSite', call: site),
        clone_page: double('ClonePage', call: build(:page, id: 42, title: 'Home CLONED', path: 'cloned-page'))
      }
    end
  end

  context 'Given the editor is not authenticated' do
    it 'returns a 401 error (unauthorized)' do
      post "/maglev/api/pages/#{page.id}/clones", as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'Given the editor is authenticated' do
    before { api_sign_in }

    it 'creates a clone of the page' do
      post "/maglev/api/pages/#{page.id}/clones", as: :json
      expect(response).to have_http_status(:ok)
      expect(json_response['title']).to eq 'Home CLONED'
    end
  end
end
