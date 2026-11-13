# frozen_string_literal: true

require 'rails_helper'

describe 'Maglev::Editor::SectionBlocks', type: :request do
  let(:theme) { build(:theme, :predefined_pages) }
  let!(:site) { Maglev::GenerateSite.call(theme: theme) }
  let!(:home_page) { Maglev::Page.home.first }
  let(:main_store) { fetch_sections_store('main', home_page.id) }
  let(:section) { main_store.find_section_by_type('showcase') }
  let(:section_id) { section['id'] }

  before do
    allow(Maglev.local_themes).to receive(:first).and_return(theme)
  end

  # the navbar is a site scoped section presenting its blocks as a tree:
  # it is listed in the "header" layout store (its "slot") while its content
  # lives in the global site scoped store
  shared_context 'with a site scoped section with nested blocks' do
    let(:slot_store) { fetch_sections_store('header') }
    let(:site_store) { fetch_sections_store('_site') }
    let(:navbar_section) { site_store.find_section_by_type('navbar') }
    let(:section_id) { navbar_section['id'] }

    # rubocop:disable Style/StringHashKeys
    before do
      # two root menu items, one of them with a nested menu item
      navbar_section['blocks'] = [
        {
          'id' => 'menu-item-0',
          'type' => 'menu_item',
          'settings' => [
            { 'id' => 'label', 'value' => 'Home' },
            { 'id' => 'link', 'value' => '/' }
          ]
        },
        {
          'id' => 'menu-item-1',
          'type' => 'menu_item',
          'settings' => [
            { 'id' => 'label', 'value' => 'About us' },
            { 'id' => 'link', 'value' => '/about-us' }
          ]
        },
        {
          'id' => 'nested-menu-item',
          'type' => 'menu_item',
          'parent_id' => 'menu-item-1',
          'settings' => [
            { 'id' => 'label', 'value' => 'Nested item' },
            { 'id' => 'link', 'value' => { 'link_type' => 'url', 'href' => '/nested', 'open_new_window' => false } }
          ]
        }
      ]
      site_store.sections_translations_will_change!
      site_store.save!
    end
    # rubocop:enable Style/StringHashKeys
  end

  describe 'GET /maglev/editor/:context/sections/:id/blocks' do
    it 'returns a success response' do
      get "/maglev/editor/en/#{home_page.id}/sections/#{section_id}/blocks"
      expect(response).to be_successful
    end

    context 'when the section presents its blocks as a tree' do
      include_context 'with a site scoped section with nested blocks'

      it 'renders each block exactly once' do
        get "/maglev/editor/en/#{home_page.id}/sections/#{section_id}/blocks"
        expect(response).to be_successful
        expect(response.body.scan('Nested item').count).to eq 1
      end

      it 'nests the child block under its parent' do
        get "/maglev/editor/en/#{home_page.id}/sections/#{section_id}/blocks"
        expect(response.body).to include('data-sortable-scope-value="menu-item-1"')
      end
    end
  end

  describe 'POST /maglev/editor/:context/sections/:id/blocks' do
    it 'returns a redirect response' do
      expect do
        post "/maglev/editor/en/#{home_page.id}/sections/#{section_id}/blocks", params: { block_type: 'item' }
        expect(response).to redirect_to("/maglev/editor/en/#{home_page.id}/sections/#{section_id}/blocks")
      end.to change { main_store.reload.sections.dig(1, 'blocks').count }.by(1)
    end
  end

  describe 'GET /maglev/editor/:context/sections/:id/blocks/:id/edit' do
    let(:block_id) { section.dig('blocks', 0, 'id') }
    it 'returns a success response' do
      get "/maglev/editor/en/#{home_page.id}/sections/#{section_id}/blocks/#{block_id}/edit"
      expect(response).to be_successful
    end

    describe "when the section doesn't exist anymore" do
      it 'returns a 404 response' do
        get "/maglev/editor/en/#{home_page.id}/sections/not_existing/blocks/not_existing/edit"
        expect(response).to redirect_to("/maglev/editor/en/#{home_page.id}/sections")
      end
    end

    describe "when the block doesn't exist anymore" do
      it 'returns a 404 response' do
        get "/maglev/editor/en/#{home_page.id}/sections/#{section_id}/blocks/not_existing/edit"
        expect(response).to redirect_to("/maglev/editor/en/#{home_page.id}/sections")
      end
    end
  end

  describe 'PUT /maglev/editor/:context/sections/:id/blocks/:id' do
    let(:block_id) { section.dig('blocks', 0, 'id') }
    it 'returns a success response' do
      params = { section_block: { title: 'My new title 🍔' } }
      put "/maglev/editor/en/#{home_page.id}/sections/#{section_id}/blocks/#{block_id}",
          as: :turbo_stream,
          params: params
      expect(response).to be_successful
      expect(main_store.reload.sections.dig(1, 'blocks', 0, 'settings', 0, 'value')).to eq 'My new title 🍔'
    end

    context 'when the section is site scoped' do
      include_context 'with a site scoped section with nested blocks'

      let(:block_id) { 'nested-menu-item' }

      before do
        # make sure the lock versions of the slot store and the site scoped store differ
        # rubocop:disable Rails/SkipsModelValidations
        slot_store.update_column(:lock_version, 0)
        site_store.update_column(:lock_version, 7)
        # rubocop:enable Rails/SkipsModelValidations
      end

      it 'renders the form with the lock version of the site scoped store' do
        get "/maglev/editor/en/#{home_page.id}/sections/#{section_id}/blocks/#{block_id}/edit"
        expect(response.body).to have_selector("input[name='lock_version'][value='7']", visible: :hidden)
      end

      it 'updates the site scoped store and dispatches its fresh lock version' do
        put "/maglev/editor/en/#{home_page.id}/sections/#{section_id}/blocks/#{block_id}",
            as: :turbo_stream,
            params: { lock_version: 7, section_block: { label: 'Our dream team' } }
        expect(response).to be_successful
        expect(response.body).to include('&quot;lockVersion&quot;:8')
        expect(site_store.reload.lock_version).to eq 8
        expect(slot_store.reload.lock_version).to eq 0
      end

      it 'still rejects a stale lock version' do
        put "/maglev/editor/en/#{home_page.id}/sections/#{section_id}/blocks/#{block_id}",
            as: :turbo_stream,
            params: { lock_version: 6, section_block: { label: 'Our dream team' } }
        expect(response).to have_http_status(:conflict)
      end
    end
  end

  describe 'DELETE /maglev/editor/:context/sections/:id/blocks/:id' do
    let(:block_id) { section.dig('blocks', 0, 'id') }
    it 'returns a redirect response' do
      expect do
        delete "/maglev/editor/en/#{home_page.id}/sections/#{section_id}/blocks/#{block_id}"
        expect(response).to redirect_to("/maglev/editor/en/#{home_page.id}/sections/#{section_id}/blocks")
      end.to change { main_store.reload.sections.dig(1, 'blocks').count }.by(-1)
    end
  end

  describe 'PUT /maglev/editor/:context/sections/:id/blocks/sort' do
    it 'returns a success response' do
      original_block_ids = section['blocks'].map { |block| block['id'] }
      put "/maglev/editor/en/#{home_page.id}/sections/#{section_id}/blocks/sort",
          params: { item_ids: original_block_ids.reverse, lock_version: section['lock_version'] }
      expect(response).to redirect_to("/maglev/editor/en/#{home_page.id}/sections/#{section_id}/blocks")
      expect(main_store.reload.section_block_ids(section_id)).to eq(original_block_ids.reverse)
    end
  end
end
