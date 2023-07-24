# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::Admin::DashboardController', type: :request do
  before do
    Maglev.configure do |config|
      config.admin_username = 'admin'
      config.admin_password = 'easyone'
    end
  end

  context 'the admin is not authenticated' do
    it 'redirects the user to the index page of the site' do
      get '/maglev/admin'
      expect(response.status).to eq(401)
    end
  end

  context 'the admin is authenticated' do
    let(:authorization) { ActionController::HttpAuthentication::Basic.encode_credentials('admin', 'easyone') }

    # rubocop:disable Style/StringHashKeys
    it 'redirects the user to the list of themes' do
      get '/maglev/admin', headers: { 'HTTP_AUTHORIZATION' => authorization }
      expect(response).to redirect_to('/maglev/admin/theme')
    end
    # rubocop:enable Style/StringHashKeys
  end
end
