# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Content::AddSectionBlockService do
  let(:site) { create(:site) }
  let!(:page) { create(:page) }
  let(:fetch_theme) { double('FetchTheme', call: build(:theme)) }
  let(:fetch_site) { double('FetchSite', call: site) }
  let(:store) { fetch_sections_store('main', page.id) }
  let(:service) { described_class.new(fetch_site: fetch_site, fetch_theme: fetch_theme) }
  let(:section_id) { store.sections.dig(1, 'id') } # showcase section
  let(:parent_id) { nil }
  let(:lock_version) { nil }

  before { store.prepare_sections(fetch_theme.call) }

  subject(:service_call) do
    service.call(store: store, section_id: section_id, block_type: block_type, parent_id: parent_id,
                 lock_version: lock_version)
  end

  context 'Given a block type that does not exist' do
    let(:block_type) { 'not_existing' }

    it 'raises an error' do
      expect { subject }.to raise_error(Maglev::Errors::UnknownBlock)
    end
  end

  context 'Given a valid block type' do
    let(:block_type) { 'item' }

    it 'adds the block to the section' do
      expect { subject }.to change { store.sections.dig(1, 'blocks').count }.by(1)
    end

    it 'returns the block' do
      expect(subject).to match(hash_including(
                                 id: kind_of(String),
                                 type: 'item',
                                 settings: kind_of(Array)
                               ))
    end

    context 'Given the page has been modified while adding the block' do
      let(:lock_version) { 1 }

      before { store.sections[1]['lock_version'] = 2 }

      it 'raises an exception about the stale page' do
        expect { subject }.to raise_exception(ActiveRecord::StaleObjectError)
      end
    end
  end

  context 'Given a parent id' do
    let(:store) { create(:sections_content_store, :header) }
    let!(:site_scoped_store) { create(:sections_content_store, :header, :site_scoped) }
    let(:section_id) { store.sections.dig(0, 'id') } # navbar section
    let(:block_type) { 'menu_item' }
    let(:parent_id) { 'menu-item-1' }

    it 'adds the block to the section' do
      expect { subject }.to change { site_scoped_store.reload.sections.dig(0, 'blocks').count }.by(1)
    end

    it 'sets the parent id' do
      subject
      expect(site_scoped_store.reload.sections.dig(0, 'blocks').last['parent_id']).to eq 'menu-item-1'
    end
  end
end
