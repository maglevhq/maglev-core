# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Content::AddSectionBlockService do
  subject(:service_call) { service.call(page: page, section_id: section_id, block_type: block_type) }

  let(:site) { create(:site) }
  let!(:page) { create(:page) }
  let(:fetch_theme) { double('FetchTheme', call: build(:theme)) }
  let(:fetch_site) { double('FetchSite', call: site) }
  let(:service) { described_class.new(fetch_site: fetch_site, fetch_theme: fetch_theme) }
  let(:section_id) { page.sections.dig(1, 'id') } # showcase section

  before { page.prepare_sections(fetch_theme.call) }

  context 'Given a block type that does not exist' do
    let(:block_type) { 'not_existing' }

    it 'raises an error' do
      expect { subject }.to raise_error(Maglev::Errors::UnknownBlock)
    end
  end

  context 'Given a valid block type' do
    let(:block_type) { 'showcase_item' }

    it 'adds the block to the section' do
      expect { subject }.to change { page.sections.dig(1, 'blocks').count }.by(1)
    end

    it 'returns the block' do
      expect(subject).to match(hash_including(
                                 id: kind_of(String),
                                 type: 'showcase_item',
                                 settings: kind_of(Array)
                               ))
    end
  end
end
