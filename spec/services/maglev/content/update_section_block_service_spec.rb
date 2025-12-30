# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Content::UpdateSectionBlockService do
  let(:site) { create(:site) }
  let!(:page) { create(:page) }
  let(:fetch_theme) { double('FetchTheme', call: build(:theme)) }
  let(:fetch_site) { double('FetchSite', call: site) }
  let(:store) { fetch_sections_store('main', page.id) }
  let(:section) { store.find_section_by_type('showcase') }
  let(:section_id) { section.dig('id') }
  let(:lock_version) { nil }
  let(:service) { described_class.new(fetch_site: fetch_site, fetch_theme: fetch_theme) }
  
  subject(:service_call) do
    service.call(store: store, section_id: section_id, block_id: block_id, content: content, lock_version: lock_version)
  end

  before { store.prepare_sections(fetch_theme.call) }

  context 'Given an existing page section block' do
    let(:block_id) { section.dig('blocks', 0, 'id') }
    let(:content) { { title: 'My first project [UPDATED]' } }
    let(:lock_version) { 0 }

    it 'updates the section block' do
      expect { subject }.to change { section.dig('blocks', 0, 'settings', 0, 'value') }.to('My first project [UPDATED]')
      expect(section.dig('blocks', 0, 'lock_version')).to eq(1)
    end

    context 'Given the block has been modified while updating the section block' do
      let(:lock_version) { 1 }

      before { section.dig('blocks', 0)['lock_version'] = 2 }

      it 'raises an exception about the stale page' do
        expect { subject }.to raise_exception(ActiveRecord::StaleObjectError)
      end
    end
  end
end
