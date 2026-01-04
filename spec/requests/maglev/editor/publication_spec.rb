# frozen_string_literal: true

require 'rails_helper'

describe 'Maglev::Editor::Publication', type: :request do
  let(:theme) { build(:theme, :predefined_pages) }
  let!(:site) { Maglev::GenerateSite.call(theme: theme) }
  let!(:home_page) { Maglev::Page.home.first }

  describe 'POST /maglev/editor/:locale/:page_id/publication' do
    it 'returns a success response' do
      post "/maglev/editor/en/#{home_page.id}/publication", headers: { accept: 'text/vnd.turbo-stream.html' }
      expect(response).to be_successful
    end
  end
end