# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::Admin::ThemesController', type: :request do
  it 'prints the information about the local theme + lists the sections of the first category' do
    get '/maglev/admin/theme'
    expect(response.body).to include('My simple theme')
    expect(response.body).to include('Jumbotron')
    expect(response.body).not_to include('Showcase')
  end

  it 'lists the sections of another category' do
    get '/maglev/admin/theme?category_id=features'
    expect(response.body).to include('My simple theme')
    expect(response.body).not_to include('Jumbotron')
    expect(response.body).to include('Showcase')
  end
end
