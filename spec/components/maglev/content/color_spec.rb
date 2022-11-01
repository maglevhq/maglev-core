# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Content::Color do
  let(:section_component) { double('Maglev::SectionComponent') }
  let(:content) { '#FFFFFF' }
  let(:setting) do
    double('Maglev::Section::Color', default: '#F0F0F0', id: 'color', label: 'Button color', type: 'color',
                                     options: {})
  end
  let(:color) { described_class.new(section_component, content, setting) }

  describe 'to_s method' do
    it { expect(color.to_s).to eq('#FFFFFF') }
  end

  describe 'dark?' do
    subject { color.dark? }

    context 'example1: #ffffff' do
      let(:content) { '#FFFFFF' }

      it { is_expected.to eq false }
    end

    context 'example2: #11ADA9' do
      let(:content) { '#11ADA9' }

      it { is_expected.to eq true }
    end

    context 'example3: #DD5044' do
      let(:content) { '#DD5044' }

      it { is_expected.to eq true }
    end
  end

  describe 'light?' do
    subject { color.light? }

    context 'example1: #ffffff' do
      let(:content) { '#FFFFFF' }

      it { is_expected.to eq true }
    end

    context 'example2: #11ADA9' do
      let(:content) { '#11ADA9' }

      it { is_expected.to eq false }
    end
  end
end
