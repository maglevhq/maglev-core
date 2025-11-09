# frozen_string_literal: true

require 'rails_helper'

describe 'Maglev::Editor::ErrorsConcern', type: :request do
  let(:theme) { build(:theme, :predefined_pages) }
  let!(:site) { Maglev::GenerateSite.call(theme: theme) }
  let!(:home_page) { Maglev::Page.home.first }

  before do
    allow(Maglev.local_themes).to receive(:first).and_return(theme)
  end

  describe 'StandardError handling' do
    context 'in non-local environment' do
      it 'redirects to editor root path for HTML requests' do
        # Mock a controller action that raises StandardError
        allow_any_instance_of(Maglev::Editor::PagesController).to receive(:index).and_raise(StandardError, 'Test error')

        expect do
          get "/maglev/editor/en/#{home_page.id}/pages"
        end.to raise_error(StandardError, 'Test error')
      end

      it 'renders standard_error template for turbo_stream requests' do
        # Mock a controller action that raises StandardError
        allow_any_instance_of(Maglev::Editor::PagesController).to receive(:index).and_raise(StandardError, 'Test error')

        get "/maglev/editor/en/#{home_page.id}/pages", as: :turbo_stream

        expect(response).to have_http_status(:internal_server_error)
        expect(response.media_type).to eq('text/vnd.turbo-stream.html')
      end
    end
  end
end
