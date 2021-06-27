# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::Admin::DashboardController', type: :request do
  it 'redirects the user to the list of themes' do
    get '/maglev/admin'
    expect(response).to redirect_to('/maglev/admin/theme')
  end
end
