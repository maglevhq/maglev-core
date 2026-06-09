# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::Studio::SectionPreviewController, type: :request do
  let(:theme) { build(:theme, :predefined_pages) }
  let!(:site) { Maglev::GenerateSite.call(theme: theme) }

  describe 'GET /maglev/studio/section_preview/:slug' do
    it 'renders a fresh section from theme defaults without loading a page from the DB' do
      home_page = Maglev::Page.home.first
      home_page.sections.find { |s| s['type'] == 'showcase' }['settings']
               .find { |s| s['id'] == 'title' }['value'] = 'DB PAGE TITLE'

      get '/maglev/studio/section_preview/showcase'

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq('text/html')
      expect(response.body).to include('data-maglev-section-type="showcase"')
      expect(response.body).not_to include('DB PAGE TITLE')
    end

    it 'returns not found for an unknown section type' do
      get '/maglev/studio/section_preview/unknown_section_type'

      expect(response).to have_http_status(:not_found)
    end
  end
end
