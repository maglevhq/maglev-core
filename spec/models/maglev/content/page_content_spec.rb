# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::Content::PageContent do
  let(:theme) { build(:theme) }
  let(:page) { build(:page) }
  let(:header_sections) { build(:sections_content_store, :header).sections }
  let(:main_sections) { build(:sections_content_store, page: page).sections }
  let(:footer_sections) { build(:sections_content_store, :footer).sections }
  let(:stores) do
    [
      { id: 'header', handle: 'header', sections: header_sections, lock_version: 0 },
      { id: 'main', handle: 'main', sections: main_sections, lock_version: 0 },
      { id: 'footer', handle: 'footer', sections: footer_sections, lock_version: 0 }
    ]
  end

  let(:instance) { described_class.new(page: page, theme: theme, stores: stores) }

  it 'returns the page content' do
    expect(instance.stores.size).to eq(3)
  end

  describe '#single_store?' do
    subject { instance.single_store? }

    it { is_expected.to eq false }

    context 'when the page has only one store' do
      let(:stores) { [{ id: 'header', sections: header_sections, lock_version: 0 }] }

      it 'returns true' do
        expect(subject).to eq true
      end
    end
  end

  describe '#sections_of' do
    it 'returns the sections of the given handle' do
      expect(instance.sections_of(:header).size).to eq 1
      expect(instance.sections_of(:main).size).to eq 2
      expect(instance.sections_of(:footer).size).to eq 0
    end
  end

  describe '#sections' do
    subject { instance.sections.size }

    it { is_expected.to eq 3 }
  end

  describe '#sticky_section_ids' do
    subject { instance.sticky_section_ids }

    it { is_expected.to eq [] }
  end
end
