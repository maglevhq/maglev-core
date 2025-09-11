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

  describe 'POST /maglev/editor/:context/sections/:id/blocks' do
    it 'returns a redirect response' do
      expect do
        post "/maglev/editor/en/#{home_page.id}/sections/#{section_id}/blocks", params: { block_type: 'item' }
        expect(response).to redirect_to("/maglev/editor/en/#{home_page.id}/sections/#{section_id}/blocks")
      end.to change { home_page.reload.sections.dig(2, 'blocks').count }.by(1)
    end
  end

  describe 'GET /maglev/editor/:context/sections/:id/blocks/:id/edit' do
    let(:block_id) { home_page.sections.dig(2, 'blocks', 0, 'id') }
    it 'returns a success response' do
      get "/maglev/editor/en/#{home_page.id}/sections/#{section_id}/blocks/#{block_id}/edit"
      expect(response).to be_successful
    end
  end

  describe 'PUT /maglev/editor/:context/sections/:id/blocks/:id' do
    let(:block_id) { home_page.sections.dig(2, 'blocks', 0, 'id') }
    it 'returns a success response' do
      params = { section_block: { title: 'My new title 🍔' } }
      put "/maglev/editor/en/#{home_page.id}/sections/#{section_id}/blocks/#{block_id}",
          as: :turbo_stream,
          params: params
      expect(response).to be_successful
      expect(home_page.reload.sections.dig(2, 'blocks', 0, 'settings', 0, 'value')).to eq 'My new title 🍔'
    end
  end

  describe 'DELETE /maglev/editor/:context/sections/:id/blocks/:id' do
    let(:block_id) { home_page.sections.dig(2, 'blocks', 0, 'id') }
    it 'returns a redirect response' do
      expect do
        delete "/maglev/editor/en/#{home_page.id}/sections/#{section_id}/blocks/#{block_id}"
        expect(response).to redirect_to("/maglev/editor/en/#{home_page.id}/sections/#{section_id}/blocks")
      end.to change { home_page.reload.sections.dig(2, 'blocks').count }.by(-1)
    end
  end
end
