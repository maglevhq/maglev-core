# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::Api::SectionsContentController', type: :request do
  let!(:site) { create(:site) }
  let!(:page) { create(:page) }

  before do
    allow(Maglev::I18n).to receive(:available_locales).and_return(%i[en fr])
    Maglev.configure do |config|
      config.services = {
        context: double('Context', controller: double('Controller')),
        fetch_site: double('FetchSite', call: site),
        fetch_theme: double('FetchTheme', call: build(:theme, :basic_layouts)),
        get_base_url: double('getBaseUrl', call: '/maglev/preview'),
        generate_site: double('GenerateSite', call: site)
      }
    end
  end

  context 'Given the editor is not authenticated' do
    it 'returns a 401 error (unauthorized)' do
      get maglev.api_page_sections_content_path(page), as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'Given the editor is authenticated' do
    before { api_sign_in }

    it 'allows retrieval of pages' do
      get maglev.api_page_sections_content_path(page), as: :json
      # rubocop:disable Style/StringHashKeys
      expect(json_response).to match([
                                       { 'id' => 'header', 'sections' => [], 'lockVersion' => 0 },
                                       { 'id' => 'main', 'sections' => [], 'lockVersion' => 0 },
                                       { 'id' => 'footer', 'sections' => [], 'lockVersion' => 0 }
                                     ])
      # rubocop:enable Style/StringHashKeys
    end

    describe 'Updating sections content' do
      context 'Given a simple case' do
        let(:sections_content) do
          JSON.parse([
            {
              id: 'header',
              sections: attributes_for(:sections_content_store, :header)[:sections]
            },
            {
              id: 'main',
              sections: attributes_for(:sections_content_store)[:sections]
            },
            {
              id: 'footer',
              sections: []
            }
          ].to_json)
        end

        it 'updates the stores in DB' do
          put maglev.api_page_sections_content_path(page), params: { sections_content: sections_content }, as: :json
          expect(response).to have_http_status(:ok)
          # rubocop:disable Style/StringHashKeys
          expect(json_response).to match({
                                           'lockVersions' => { 'footer' => 1, 'header' => 1, 'main' => 1 }
                                         })
          # rubocop:enable Style/StringHashKeys
        end
      end

      context 'Given the page has been updated in the meantime' do
        let!(:header_store) { create(:sections_content_store, :header) }

        let(:sections_content) do
          JSON.parse([
            {
              id: 'header',
              sections: attributes_for(:sections_content_store, :header)[:sections],
              lock_version: 1
            }
          ].to_json)
        end

        it 'returns a conflict error code (409)' do
          put maglev.api_page_sections_content_path(page), params: { sections_content: sections_content }, as: :json
          expect(response).to have_http_status(:conflict)
        end
      end
    end
  end
end
