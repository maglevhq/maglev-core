# frozen_string_literal: true

require 'rails_helper'

describe 'Maglev::Editor::PageClones', type: :request do
  let(:theme) { build(:theme, :predefined_pages) }
  let!(:site) { Maglev::GenerateSite.call(theme: theme) }
  let!(:home_page) { Maglev::Page.home.first }

  describe 'POST /maglev/editor/:context/pages/:id/clone' do
    it 'returns a redirect response' do
      expect do
        post "/maglev/editor/en/#{home_page.id}/pages/#{home_page.id}/clone"
        expect(response).to be_redirect
        expect(flash[:notice]).to eq 'Cloned!'
      end.to change(Maglev::Page, :count).by(1)
    end
  end
end
