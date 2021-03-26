# frozen_string_literal: true

require 'rails_helper'

describe Maglev do
  describe '.VERSION' do
    subject { Maglev::VERSION }
    it { is_expected.not_to eq nil }
  end

  describe 'config' do
    it 'provides a default favicon' do
      expect(Maglev.config.favicon).to eq('favicon.ico')
    end

    it 'provides a default logo' do
      expect(Maglev.config.logo).to eq('logo.png')
    end

    it 'provides a default primary color' do
      expect(Maglev.config.primary_color).to eq('#7362D0')
    end
  end

  describe '#configure' do
    let!(:original) { Maglev.config.favicon }
    after { Maglev.config.favicon = original }

    it 'yields the config' do
      Maglev.configure do |config|
        config.favicon = 'someicon.ico'
      end

      expect(Maglev.config.favicon).to eq('someicon.ico')
    end
  end
end
