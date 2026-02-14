# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Content::UnlinkMirroredSectionService do
  let(:site) { create(:site) }
  let(:page) { create(:page, sections: nil) }
  let(:theme) { build(:theme) }
  let(:fetch_theme) { double('FetchTheme', call: theme) }
  let(:fetch_site) { double('FetchSite', call: site) }
  let(:store) do
    create(:sections_content_store, :mirrored_section, section_id: section_id, source_page: source_page,
                                                       source_store: source_store)
  end
  let(:section_id) { 'jumbotron-0' }

  let(:source_page) { create(:page, title: 'Another page', path: 'another-page', sections: nil) }
  let(:source_store) { create(:sections_content_store, page: source_page) }

  let(:service) { described_class.new(fetch_site: fetch_site, fetch_theme: fetch_theme) }

  subject(:service_call) do
    service.call(store: store, section_id: section_id)
  end

  context 'Given an existing page section' do
    let(:lock_version) { 0 }

    it 'unlinks the mirrored section' do
      expect(subject).to eq(true)
      expect(store.sections.dig(0, 'mirror_of', 'enabled')).to eq false
    end

    it 'copies the source content to the store' do
      subject
      expect(store.find_section_by_type('jumbotron').dig('settings', 0, 'value')).to eq('Hello world')
    end
  end
end
