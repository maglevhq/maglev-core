# frozen_string_literal: true

require 'rails_helper'

describe 'Maglev::Editor::SectionBlocks', type: :request do
  let(:theme) { build(:theme, :predefined_pages) }
  let!(:site) { Maglev::GenerateSite.call(theme: theme) }
  let!(:home_page) { Maglev::Page.home.first }
  let(:section_id) { home_page.sections.dig(2, 'id') }

  before do
    allow(Maglev.local_themes).to receive(:first).and_return(theme)
  end

  describe 'GET /maglev/editor/:context/sections/:id/blocks' do
    it 'returns a success response' do
      get "/maglev/editor/en/#{home_page.id}/sections/#{section_id}/blocks"
      expect(response).to be_successful
    end
  end

  describe 'GET /maglev/editor/:context/sections/:id/blocks/:id/edit' do
    let(:block_id) { home_page.sections.dig(2, 'blocks', 0, 'id') }
    it 'returns a success response' do
      get "/maglev/editor/en/#{home_page.id}/sections/#{section_id}/blocks/#{block_id}/edit"
      expect(response).to be_successful
    end
  end
end
