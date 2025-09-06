# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Content::SortSectionBlocksService do
  let(:theme) { build(:theme) }
  let(:site) { create(:site) }
  let(:page) { create(:page, number_of_showcase_blocks: 4) }
  let(:section_id) { page.sections.dig(1, 'id') }
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

  before { page.prepare_sections(theme) }

  subject { service.call(page: page, section_id: section_id, block_ids: block_ids) }

  it 'sorts the blocks' do
    expect { subject }.to change {
      page.sections.dig(1, 'blocks').map do |block|
        block['settings'].dig(0, 'value')
      end
    }.to ['My project #4', 'My first project', 'My project #3', 'My project #2']
  end
end
