# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::API::PagesController', type: :request do
  let!(:site) { create(:site) }
  let!(:page) { create(:page) }

  before do
    Maglev.configure do |config|
      config.services = {
        context: double('Context', controller: double('Controller')),
        fetch_site: double('FetchSite', call: site),
        fetch_theme: double('FetchTheme', call: build(:theme)),
        get_base_url: double('getBaseUrl', call: '/maglev/preview'),
        generate_site: double('GenerateSite', call: site)
      }
    end
  end

  it 'allows retrieval of pages' do
    get '/maglev/api/pages', as: :json
    expect(json_response.size).to eq 1
    expect(json_response.first.deep_symbolize_keys).to include(
      {
        id: page.id,
        title: page.title,
        path: page.path,
        visible: true,
        seo_title: nil,
        meta_description: nil,
        preview_url: '/maglev/preview',
        section_names: [a_hash_including(name: 'Jumbotron'), a_hash_including(name: 'Showcase')]
      }
    )
  end

  describe 'allows retrieval of a single page' do
    before { Maglev::Translatable.with_locale(:fr) { page.update!(title: 'Bonjour', path: 'index-fr') } }
    it 'returns an attribute listing the paths of the page in all the locales' do
      get "/maglev/api/pages/#{page.id}", as: :json
      expect(json_response['pathHash']).to eq({ 'en' => 'index', 'fr' => 'index-fr' })
    end
  end

  describe 'allows retrieval of pages based on keyword' do
    it 'returns an empty array if the keyword is empty' do
      get '/maglev/api/pages', params: { q: '' }, as: :json
      expect(json_response).to eq([].as_json)
    end

    it 'returns the pages whose title matches the keyword' do
      get '/maglev/api/pages', params: { q: 'Hom' }, as: :json
      expect(json_response.size).to eq 1
      expect(json_response.first.deep_symbolize_keys).to include(
        {
          id: page.id,
          title: page.title,
          path: page.path,
          visible: true,
          seo_title: nil,
          meta_description: nil,
          preview_url: '/maglev/preview',
          section_names: [a_hash_including(name: 'Jumbotron'), a_hash_including(name: 'Showcase')]
        }
      )
    end
  end

  it 'allows creation of new pages' do
    expect do
      params = attributes_for(:page).merge(path: 'custom')
      post '/maglev/api/pages', params: { page: params}, as: :json
    end.to change(Maglev::Page, :count).by(1)
    expect(response).to have_http_status(:created)
  end

  it 'returns well-formed error response on wrong creation request' do
    post '/maglev/api/pages', params: { page: { title: '', path: 'new' } }, as: :json
    expect(json_response).to eq(
      {
        errors: { title: ["can't be blank"] }
      }.as_json
    )
    expect(response).to have_http_status(:bad_request)
  end

  it 'allows deletion of pages' do
    expect { delete maglev.api_page_path(page), as: :json }.to change(Maglev::Page, :count).by(-1)
    expect(response).to have_http_status(:no_content)
  end

  it 'allows updating pages' do
    expect do
      put maglev.api_page_path(page), params: { page: { title: 'New title' } }, as: :json
    end.to change { page.reload.title }.to('New title')
    expect(response).to have_http_status(:ok)
  end
end
