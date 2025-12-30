# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Content::DeleteSectionBlockService do
  let(:theme) { build(:theme) }
  let(:site) { create(:site) }
  let(:page) { create(:page) }
  let(:store) { fetch_sections_store('main', page.id) }
  let(:section) { store.find_section_by_type('showcase') }
  let(:section_id) { section.dig('id') }
  let(:block_id) { section.dig('blocks', 0, 'id') }
  let(:fetch_theme) { double('FetchTheme', call: theme) }
  let(:fetch_site) { double('FetchSite', call: site) }
  let(:lock_version) { nil }
  let(:service) { described_class.new(fetch_site: fetch_site, fetch_theme: fetch_theme) }

  before { store.prepare_sections(theme) }

  subject { service.call(store: store, section_id: section_id, block_id: block_id, lock_version: lock_version) }

  it 'deletes the block' do
    expect { subject }.to change(section.dig('blocks'), :size).by(-1)
  end

  context 'Given the page has been modified while deleting the block' do
    let(:lock_version) { 1 }

    before { section['lock_version'] = 2 }

    it 'raises an exception about the stale page' do
      expect { subject }.to raise_exception(ActiveRecord::StaleObjectError)
    end
  end
end
