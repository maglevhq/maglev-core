# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Section do
  describe 'validation' do
    let(:section) { build(:section) }
    subject { section.valid? }
    it { is_expected.to eq true }

    context 'id is required' do
      let(:section) { build(:section, id: nil) }
      it { is_expected.to eq false }
    end

    context 'name is required' do
      let(:section) { build(:section, name: nil) }
      it { is_expected.to eq false }
    end

    context 'category is required' do
      let(:section) { build(:section, category: nil) }
      it { is_expected.to eq false }
    end

    context 'settings must be valid' do
      let(:section) { build(:section, :invalid_settings) }
      it { is_expected.to eq false }
    end

    context 'blocks must be valid' do
      let(:section) { build(:section, :invalid_block) }
      it { is_expected.to eq false }
    end
  end
end
