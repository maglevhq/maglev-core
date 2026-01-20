# frozen_string_literal: true

require 'rails_helper'

describe 'Maglev::Editor::Pages::Rollback', type: :request do
  let(:theme) { build(:theme, :predefined_pages) }
  let!(:site) { Maglev::GenerateSite.call(theme: theme) }
  let!(:home_page) { Maglev::Page.home.first }

  before do
    allow(Maglev.local_themes).to receive(:first).and_return(theme)
  end

  describe 'POST /maglev/editor/:context/pages/:id/rollback' do
    context 'when page has never been published' do
      it 'raises UnpublishedPage error' do
        expect do
          post "/maglev/editor/en/#{home_page.id}/pages/#{home_page.id}/rollback", as: :turbo_stream
        end.to raise_error(Maglev::Errors::UnpublishedPage)
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
        post "/maglev/editor/en/#{home_page.id}/pages/#{home_page.id}/rollback", as: :turbo_stream

        expect(response).to be_successful
        expect(response.media_type).to eq('text/vnd.turbo-stream.html')
      end

      it 'restores sections from published store' do
        published_sections = home_page.sections_content_stores.published.first.sections_translations

        post "/maglev/editor/en/#{home_page.id}/pages/#{home_page.id}/rollback", as: :turbo_stream

        home_page.reload
        expect(home_page.sections_translations).to eq(published_sections)
      end

      it 'updates updated_at to be before published_at' do
        published_at = home_page.published_at

        post "/maglev/editor/en/#{home_page.id}/pages/#{home_page.id}/rollback", as: :turbo_stream

        home_page.reload
        expect(home_page.updated_at).to be < published_at
      end
    end
  end
end
