# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Spacing do
  describe '.mobile_px_for' do
    it 'returns correct pixel value for a known size' do
      expect(described_class.mobile_px_for(:sm)).to eq(16)
      expect(described_class.mobile_px_for('md')).to eq(24)
    end

    it 'returns the default mobile pixel value for an unknown size' do
      expect(described_class.mobile_px_for(:unknown)).to eq(24)
    end
  end

  describe '.desktop_px_for' do
    it 'returns correct pixel value for a known size' do
      expect(described_class.desktop_px_for(:lg)).to eq(80)
      expect(described_class.desktop_px_for('xl')).to eq(120)
    end

    it 'returns the default desktop pixel value for an unknown size' do
      expect(described_class.desktop_px_for(:unknown)).to eq(40)
    end
  end

  describe '.mobile_css_for' do
    it 'returns correct CSS format' do
      expect(described_class.mobile_css_for(:xs)).to eq('8px')
      expect(described_class.mobile_css_for(:unknown)).to eq('24px')
    end
  end

  describe '.desktop_css_for' do
    it 'returns correct CSS format' do
      expect(described_class.desktop_css_for(:md)).to eq('40px')
      expect(described_class.desktop_css_for(:unknown)).to eq('40px')
    end
  end
end
