# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Section::Block do
  describe 'validation' do
    subject { block.valid? }

    let(:block) { build(:section_block) }

    it { is_expected.to eq true }

    context 'name is required' do
      let(:block) { build(:section_block, name: nil) }

      it { is_expected.to eq false }
    end

    context 'type is required' do
      let(:block) { build(:section_block, type: nil) }

      it { is_expected.to eq false }
    end
  end
end
