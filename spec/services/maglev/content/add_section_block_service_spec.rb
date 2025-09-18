# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Content::AddSectionBlockService do  
  let(:site) { create(:site, :empty) }
  let!(:page) { create(:page) }
  let(:fetch_theme) { double('FetchTheme', call: build(:theme)) }
  let(:fetch_site) { double('FetchSite', call: site) }
  let(:service) { described_class.new(fetch_site: fetch_site, fetch_theme: fetch_theme) }
  let(:section_id) { page.sections.dig(1, 'id') } # showcase section
  let(:parent_id) { nil }

  before { page.prepare_sections(fetch_theme.call) }

  subject(:service_call) { service.call(page: page, section_id: section_id, block_type: block_type, parent_id: parent_id) }


  context 'Given a block type that does not exist' do
    let(:block_type) { 'not_existing' }

    it 'raises an error' do
      expect { subject }.to raise_error(Maglev::Errors::UnknownBlock)
    end
  end

  context 'Given a valid block type' do
    let(:block_type) { 'item' }

    it 'adds the block to the section' do
      expect { subject }.to change { page.sections.dig(1, 'blocks').count }.by(1)
    end

    it 'returns the block' do
      expect(subject).to match(hash_including(
                                 id: kind_of(String),
                                 type: 'item',
                                 settings: kind_of(Array)
                               ))
    end
  end

  context 'Given a parent id' do
    let(:page) { create(:page, :with_navbar) }
    let(:section_id) { page.sections.dig(0, 'id') } # navbar section
    let(:block_type) { 'menu_item' }
    let(:parent_id) { 'menu-item-1' }

    before { site.update(sections: [page.sections[0]]) } # in a site scoped section, site + page shares the same instance of the section

    it 'adds the block to the section' do
      expect { subject }.to change { page.sections.dig(0, 'blocks').count }.by(1)
    end

    it 'sets the parent id' do
      subject
      expect(page.sections.dig(0, 'blocks').last['parent_id']).to eq 'menu-item-1'
    end
  end
end
