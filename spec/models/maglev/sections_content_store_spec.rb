# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::SectionsContentStore, type: :model do
  it 'has a valid factory' do
    expect(build(:sections_content_store)).to be_valid
  end

  describe 'validation' do
    subject { store.valid? }

    context 'no handle' do
      let(:store) { build(:sections_content_store, handle: nil) }

      it { is_expected.to eq false }
    end

    context 'the handle has already been taken' do
      let!(:first_store) { create(:sections_content_store) }
      let(:store) { build(:sections_content_store) }

      it { is_expected.to eq false }
    end
  end
end
