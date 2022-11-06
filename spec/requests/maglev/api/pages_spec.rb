# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::Api::PagesController', type: :request do
  let!(:site) { create(:site) }
  let!(:page) { create(:page) }

  before do
    allow(Maglev::I18n).to receive(:available_locales).and_return(%i[en fr])
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

  context 'Given the editor is not authenticated' do
    it 'returns a 401 error (unauthorized)' do
      get '/maglev/api/pages', as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'Given the editor is authenticated' do
    before { api_sign_in }

    it 'allows retrieval of pages' do
      get '/maglev/api/pages', as: :json
      expect(json_response.size).to eq 3
      expect(json_response.first.deep_symbolize_keys).to include(
        {
          id: page.id,
          title: page.title,
          path: page.path,
          visible: true,
          seo_title: nil,
          meta_description: nil,
          og_title: nil,
          og_description: nil,
          og_image_url: nil,
          preview_url: '/maglev/preview',
          section_names: [a_hash_including(name: 'Jumbotron'), a_hash_including(name: 'Showcase')]
        }
      )
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
            og_title: nil,
            og_description: nil,
            og_image_url: nil,
            preview_url: '/maglev/preview',
            section_names: [a_hash_including(name: 'Jumbotron'), a_hash_including(name: 'Showcase')]
          }
        )
      end
    end

    # rubocop:disable Style/StringHashKeys
    describe 'allows retrieval of a single page' do
      it 'returns a page based on its path' do
        page.update(title: 'Foo foo!', path: 'foo/foo')
        get '/maglev/api/pages/foo%2Ffoo', as: :json
        expect(json_response['title']).to eq 'Foo foo!'
      end

      it 'returns the lock version of the page' do
        get "/maglev/api/pages/#{page.id}", as: :json
        expect(json_response['lockVersion']).to eq 0
      end

      context 'the page doesn\'t have been translated in the requested locale' do
        it 'returns the translated property set to false' do
          get "/maglev/api/pages/#{page.id}", params: { locale: 'fr' }, as: :json
          expect(json_response['translated']).to eq(false)
        end
      end

      context 'the page has been translated in the requested locale' do
        before { Maglev::I18n.with_locale(:fr) { page.update!(title: 'Bonjour', path: 'index-fr') } }

        it 'returns the translated property set to false' do
          get "/maglev/api/pages/#{page.id}", params: { locale: 'fr' }, as: :json
          expect(json_response['translated']).to eq(true)
        end

        it 'returns an attribute listing the paths of the page in all the locales' do
          get "/maglev/api/pages/#{page.id}", as: :json
          expect(json_response['pathHash']).to eq({ 'en' => 'index', 'fr' => 'index-fr' })
        end

        it 'returns the lock version of the page' do
          get "/maglev/api/pages/#{page.id}", as: :json
          expect(json_response['lockVersion']).to eq 1
        end
      end
    end
    # rubocop:enable Style/StringHashKeys

    it 'allows the creation of new pages' do
      expect do
        params = attributes_for(:page).merge(path: 'custom')
        post '/maglev/api/pages', params: { page: params }, as: :json
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

    describe 'Updating pages' do
      context 'Given a simple case' do
        it 'updates the page in DB' do
          expect do
            put maglev.api_page_path(page), params: { page: { title: 'New title' }, site: {} }, as: :json
          end.to change { page.reload.title }.to('New title')
          expect(response).to have_http_status(:ok)
          expect(response.headers['Page-Lock-Version']).to eq('1')
        end
      end

      context 'Given the page has been updated in the meantime' do
        it "doesn't update the page in DB" do
          expect do
            page.update(title: 'I changed it first')
            put maglev.api_page_path(page), params: { page: { title: 'New title', lock_version: 0 } }, as: :json
          end.to change { page.reload.title }.to('I changed it first')
          expect(response).to have_http_status(:conflict)
        end
      end

      context 'Given the site has been updated in the meantime' do
        let(:sections) { [attributes_for(:page, :with_navbar)[:sections][0]] }
        let(:site_attributes) { { sections: sections, lock_version: 0 } }
        let(:page_attributes) { { title: 'New title', lock_version: 0 } }

        it "doesn't update the page in DB" do
          expect do
            site.update(name: 'New name')
            put maglev.api_page_path(page),
                params: { page: page_attributes, site: site_attributes }, as: :json
          end.to change { site.reload.name }.to('New name')
          expect(response).to have_http_status(:conflict)
        end
      end
    end

    it 'allows deletion of pages' do
      expect { delete maglev.api_page_path(page), as: :json }.to change(Maglev::Page, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
