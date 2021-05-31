# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::Sections::DashboardController', type: :request do
  it 'prints the information about the local theme' do
    get '/maglev'
    expect(response.body).to include('My simple theme')
    expect(response.body).to include('Jumbotron')
    expect(response.body).to include('Showcase')
  end
end
