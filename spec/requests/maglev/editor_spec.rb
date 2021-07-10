# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::EditorController', type: :request do
  let(:theme) { build(:theme, :predefined_pages) }
  let!(:site) do
    Maglev::GenerateSite.call(theme: theme)
  end

  it 'renders the editor page' do
    get '/maglev/editor'
    expect(response.body).to include('My simple theme')
    expect(response.body).to include('window.baseUrl = "/maglev/editor"')
    expect(response.body).to include('window.apiBaseUrl = "/maglev/api"')
    expect(response.body).to include('window.site = {')
    expect(response.body).to include('window.theme = {')
    expect(response.body).to include('"nbRows":6')
  end
end
