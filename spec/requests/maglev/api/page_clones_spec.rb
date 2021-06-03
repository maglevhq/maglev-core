# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::API::PageClonesController', type: :request do
  let(:site) { create(:site) }
  let!(:page) { create(:page) }

  before do
    Maglev.configure do |config|
      config.services = {
        controller: double('Controller'),
        fetch_site: double('FetchSite', call: site),
        get_model_scopes: double('GetModelScopes', call: { page: Maglev::Page }),
        clone_page: double('ClonePage', call: build(:page, id: 42, path: 'cloned-page'))
      }
    end
  end

  it 'creates a clone of the page' do
    post "/maglev/api/pages/#{page.id}/clones", as: :json
    expect(response).to have_http_status(:created)
    expect(response.headers['Location']).to eq '/maglev/api/pages/42'
  end
end
