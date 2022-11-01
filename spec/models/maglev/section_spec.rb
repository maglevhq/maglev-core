# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Section do
  describe 'validation' do
    subject { section.valid? }

    let(:section) { build(:section) }

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

  describe '#build_default_content' do
    subject { section.build_default_content }

    let(:section) { build(:section, :navbar) }

    context 'no sample provided by the developer' do
      it 'returns a default and basic content for the section' do
        expect(subject[:type]).to eq 'navbar'
        expect(subject[:settings][0][:value]).to eq({ url: 'awesome-logo.png' })
        expect(subject[:blocks].size).to eq 3
        expect(subject[:blocks][0][:settings][0][:value]).to eq 'Hello world'
      end
    end

    context 'a sample has been provided by the developer' do
      let(:section) { build(:section, :navbar, :navbar_with_sample) }

      it 'returns the sample as the default content of the section' do
        expect(subject[:type]).to eq 'navbar'
        expect(subject[:settings][0][:value]).to eq({ url: 'another-awesome-logo.png' })
        expect(subject[:blocks].size).to eq 4
        expect(subject[:blocks].map do |block|
                 block[:settings][0][:value]
               end).to eq ['Home', 'About us', 'Our company', 'Our staff']
      end
    end
  end
end
