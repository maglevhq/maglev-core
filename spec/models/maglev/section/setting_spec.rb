# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Section::Setting do
  describe 'validation' do
    subject { setting.valid? }

    let(:setting) { build(:section_setting) }

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

    context 'type must include  [text, image, checkbox, link, color, select, collection_item]' do
      %w[text image checkbox link color select collection_item].each do |type|
        let(:setting) { build(:section_setting, type: type) }
        it { is_expected.to eq true }
      end
    end
  end
end
