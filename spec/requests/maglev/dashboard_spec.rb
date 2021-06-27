# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::DashboardController', type: :request do
  it 'redirects to the theme page instead' do
    get '/maglev'
    expect(response).to redirect_to('/maglev/admin')
  end
end
