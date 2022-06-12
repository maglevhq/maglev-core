# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Theme do
  describe 'validation' do
    let(:theme) { build(:theme) }
    subject { theme.valid? }
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
    let(:theme) { build(:theme) }
    subject { theme.style_settings }

    it 'returns the settings (definition) of the theme' do
      expect(subject.map(&:id)).to eq(['primary_color', 'font_name'])
    end
  end
end
