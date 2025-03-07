require 'rails_helper'

RSpec.describe Maglev::SectionContentStore, type: :model do
  it 'has a valid factory' do
    expect(build(:section_content_store)).to be_valid
  end

  describe 'validation' do
    subject { store.valid? }

    context 'no handle' do
      let(:store) { build(:section_content_store, handle: nil) }

      it { is_expected.to eq false }
    end

    context 'the handle has already been taken' do
      let!(:first_store) { create(:section_content_store) }
      let(:store) { build(:section_content_store) }

      it { is_expected.to eq false }
    end
  end
end
