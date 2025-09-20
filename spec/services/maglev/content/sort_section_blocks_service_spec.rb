# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Content::SortSectionBlocksService do
  let(:theme) { build(:theme) }
  let(:site) { create(:site, :empty) }
  let(:page) { create(:page, number_of_showcase_blocks: 4) }
  let(:section_id) { page.sections.dig(1, 'id') }
  let(:parent_id) { nil }
  let(:block_ids) do
    [
      page.sections.dig(1, 'blocks', 3, 'id'),
      page.sections.dig(1, 'blocks', 0, 'id'),
      page.sections.dig(1, 'blocks', 2, 'id'),
      page.sections.dig(1, 'blocks', 1, 'id')
    ]
  end
  let(:fetch_theme) { double('FetchTheme', call: theme) }
  let(:fetch_site) { double('FetchSite', call: site) }
  let(:service) { described_class.new(fetch_site: fetch_site, fetch_theme: fetch_theme) }
  let(:lock_version) { nil }

  before { page.prepare_sections(theme) }

  subject do
    service.call(page: page, section_id: section_id, block_ids: block_ids, parent_id: parent_id,
                 lock_version: lock_version)
  end

  it 'sorts the blocks' do
    expect { subject }.to change {
      page.sections.dig(1, 'blocks').map do |block|
        block['settings'].dig(0, 'value')
      end
    }.to ['My project #4', 'My first project', 'My project #3', 'My project #2']
  end

  context 'Given an existing page section with a version' do
    let(:lock_version) { 1 }

    before { page.sections[1]['lock_version'] = 2 }

    it 'raises an exception about the stale page' do
      expect { subject }.to raise_exception(ActiveRecord::StaleObjectError)
    end
  end

  describe 'When the blocks are sorted in the tree' do
    let(:page) { create(:page, :with_navbar) }
    let(:section_id) { page.sections.dig(0, 'id') }
    let(:parent_id) { 'menu-item-1' }
    let(:block_ids) do
      [
        page.sections.dig(0, 'blocks', 3, 'id'),
        page.sections.dig(0, 'blocks', 2, 'id')
      ]
    end

    before { site.sections.push(page.sections[0]) }

    it 'sorts the blocks' do
      expect { subject }.to change {
        page.sections.dig(0, 'blocks').map do |block|
          block['settings'].dig(0, 'value')
        end
      }.to ['Home', 'About us', 'Our office', 'Our team']
    end
  end
end
