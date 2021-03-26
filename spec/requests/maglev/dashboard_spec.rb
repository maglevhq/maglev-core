# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::Sections::Dashboard', type: :request do
  it 'lists all the themes built with Maglev' do
    get '/maglev'
    expect(response.body).to include('My simple theme')
    expect(response.body).to include('Jumbotron')
    expect(response.body).to include('Showcase')
  end
end
