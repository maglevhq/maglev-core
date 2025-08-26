# frozen_string_literal: true

require 'rails_helper'

describe 'Maglev::Editor::Home', type: :request do
  let(:theme) { build(:theme, :predefined_pages) }
  let!(:site) { Maglev::GenerateSite.call(theme: theme) }
  let!(:home_page) { Maglev::Page.home.first }

  describe 'GET /' do
    it 'returns a redirect response if page_id is not present' do
      get '/maglev/editor'
      expect(response).to redirect_to("/maglev/editor/en/#{home_page.id}")
    end

    it 'returns a success response' do
      get "/maglev/editor/en/#{home_page.id}"
      expect(response).to be_successful
    end
  end
end
