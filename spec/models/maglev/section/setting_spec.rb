# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Section::Setting do
  describe 'validation' do
    let(:setting) { build(:section_setting) }
    subject { setting.valid? }
    it { is_expected.to eq true }

    context 'id is required' do
      let(:setting) { build(:section_setting, id: nil) }
      it { is_expected.to eq false }
    end

    context 'label is required' do
      let(:setting) { build(:section_setting, label: nil) }
      it { is_expected.to eq false }
    end

    context 'type is required' do
      let(:setting) { build(:section_setting, type: nil) }
      it { is_expected.to eq false }
    end

    context 'type is accepted' do
      let(:setting) { build(:section_setting, type: 'radio') }
      it { is_expected.to eq false }
    end
  end
end
