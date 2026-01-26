# frozen_string_literal: true

require 'rails_helper'

describe 'Maglev::Editor::Pages::DiscardDraft', type: :request do
  let(:theme) { build(:theme, :predefined_pages) }
  let!(:site) { Maglev::GenerateSite.call(theme: theme) }
  let!(:home_page) { Maglev::Page.home.first }

  before do
    allow(Maglev.local_themes).to receive(:first).and_return(theme)
  end

  describe 'POST /maglev/editor/:context/pages/:id/revert' do
    context 'when page has never been published' do
      it 'returns a 422 status code' do
        post "/maglev/editor/en/#{home_page.id}/pages/#{home_page.id}/discard_draft", as: :turbo_stream
        expect(response).to have_http_status(Rails.version.to_f >= 8.0 ? :unprocessable_content : :unprocessable_entity)        
      end
    end

    context 'when page has been published' do
      before do
        Maglev::PublishService.new.call(site: site, page: home_page)
        # Modify sections to create unpublished changes
        home_page.sections_translations = { en: [{ type: 'hero', id: '123', settings: [] }] }
        home_page.save!
      end

      it 'returns a turbo_stream response' do
        post "/maglev/editor/en/#{home_page.id}/pages/#{home_page.id}/discard_draft", as: :turbo_stream

        expect(response).to be_successful
        expect(response.media_type).to eq('text/vnd.turbo-stream.html')
      end

      it 'restores sections from published store' do
        published_sections = home_page.sections_content_stores.published.first.sections_translations

        post "/maglev/editor/en/#{home_page.id}/pages/#{home_page.id}/discard_draft", as: :turbo_stream

        home_page.reload
        expect(home_page.sections_translations).to eq(published_sections)
      end
    end
  end
end
