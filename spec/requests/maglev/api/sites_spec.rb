# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::API::SitesController', type: :request do
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

  it 'allows retrieval of the current site' do
    get '/maglev/api/site', as: :json
    expect(json_response.deep_symbolize_keys).to include(
      {
        id: site.id,
        homePageId: page.id,
        sections: []
      }
    )
  end
end
