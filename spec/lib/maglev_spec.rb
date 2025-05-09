# frozen_string_literal: true

require 'rails_helper'

describe Maglev do
  describe '.VERSION' do
    subject { Maglev::VERSION }

    it { is_expected.not_to eq nil }
  end

  describe 'config' do
    it 'provides a default nil favicon' do
      expect(described_class.config.favicon).to eq(nil)
    end

    it 'provides a default nil logo' do
      expect(described_class.config.logo).to eq(nil)
    end

    it 'provides a default primary color' do
      expect(described_class.config.primary_color).to eq('#040712')
    end
  end

  describe '#configure' do
    let!(:original) { described_class.config.favicon }

    after { described_class.config.favicon = original }

    it 'yields the config' do
      described_class.configure do |config|
        config.favicon = 'someicon.ico'
      end

      expect(described_class.config.favicon).to eq('someicon.ico')
    end
  end

  describe '#uploader' do
    it 'returns the ActiveStorage uploader by default' do
      expect(described_class.uploader).to eq(::Maglev::ActiveStorage)
    end

    it 'returns the uploader if it is a string' do
      described_class.configure do |config|
        config.uploader = 'TestAssetUploader'
      end

      expect(described_class.uploader).to eq(TestAssetUploader)
    end

    it 'returns the uploader if it is a class' do
      described_class.configure do |config|
        config.uploader = TestAssetUploader
      end
      expect(described_class.uploader).to eq(TestAssetUploader)
    end
  end
end

class TestAssetUploader; end
