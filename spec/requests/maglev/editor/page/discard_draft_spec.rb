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
      it 'renders standard_error template for turbo_stream requests' do
        post "/maglev/editor/en/#{home_page.id}/pages/#{home_page.id}/discard_draft", as: :turbo_stream

        expect(response).to have_http_status(:internal_server_error)
        expect(response.media_type).to eq('text/vnd.turbo-stream.html')
      end
    end

    context 'when page has been published' do
      let(:main_store) { fetch_sections_store('main', home_page.id) }

      before do
        Maglev::PublishService.new.call(theme: theme, site: site, page: home_page)
        # Modify sections to create unpublished changes
        main_store.sections.dig(0, 'settings', 0)['value'] = 'Modified content'
        main_store.save!
      end

      it 'returns a turbo_stream response' do
        post "/maglev/editor/en/#{home_page.id}/pages/#{home_page.id}/discard_draft", as: :turbo_stream

        expect(response).to be_successful
        expect(response.media_type).to eq('text/vnd.turbo-stream.html')
      end

      it 'restores sections from published store' do
        published_store = Maglev::SectionsContentStore.published.find_by(handle: 'main', maglev_page_id: home_page.id)
        published_sections = published_store.sections_translations

        expect(main_store.reload.sections_translations).not_to eq(published_sections)

        post "/maglev/editor/en/#{home_page.id}/pages/#{home_page.id}/discard_draft", as: :turbo_stream

        expect(main_store.reload.sections_translations).to eq(published_sections)
      end
    end
  end
end
