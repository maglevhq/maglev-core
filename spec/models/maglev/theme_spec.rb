# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Theme do
  describe 'validation' do
    subject { theme.valid? }

    let(:theme) { build(:theme) }

    it { is_expected.to eq true }

    context 'id is required' do
      let(:theme) { build(:theme, id: nil) }

      it { is_expected.to eq false }
    end

    context 'name is required' do
      let(:theme) { build(:theme, name: nil) }

      it { is_expected.to eq false }
    end
  end

  describe 'settings' do
    subject { theme.style_settings }

    let(:theme) { build(:theme) }

    it 'returns the settings (definition) of the theme' do
      expect(subject.map(&:id)).to eq(%w[primary_color font_name])
    end
  end

  describe 'layouts' do
    subject { theme.layouts }

    let(:theme) { build(:theme) }

    it 'returns the layouts' do
      expect(subject.map(&:id)).to eq(%w[default sidebar])
    end

    it 'returns the groups of a layout' do
      expect(subject.first.groups.map(&:id)).to eq(%w[header main footer])
    end

    it 'sets _page handle for the main group if the page option is true' do
      expect(subject.first.groups.find { |group| group.id == 'main' }.store).to eq('_page')
    end
  end
end
