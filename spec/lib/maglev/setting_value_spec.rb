# frozen_string_literal: true

require 'rails_helper'

describe Maglev::SettingValue do
  describe '.checkbox_truthy?' do
    it 'returns the default if setting is nil' do
      expect(described_class.checkbox_truthy?(nil)).to eq(false)
      expect(described_class.checkbox_truthy?(nil, default: true)).to eq(true)
    end

    it 'returns true? when the setting responds to true?' do
      setting = double('CheckboxSetting')
      allow(setting).to receive(:true?).and_return(true)
      expect(described_class.checkbox_truthy?(setting)).to eq(true)

      setting2 = double('CheckboxSetting')
      allow(setting2).to receive(:true?).and_return(false)
      expect(described_class.checkbox_truthy?(setting2)).to eq(false)
    end

    it 'falls back to !!setting if true? is not implemented' do
      expect(described_class.checkbox_truthy?(true)).to eq(true)
      expect(described_class.checkbox_truthy?('yes')).to eq(true)
      expect(described_class.checkbox_truthy?(false)).to eq(false)
    end
  end

  describe '.select_string' do
    it 'returns default if setting is nil' do
      expect(described_class.select_string(nil)).to eq(nil)
      expect(described_class.select_string(nil, default: 'fallback')).to eq('fallback')
    end

    it 'returns setting string representation if present' do
      expect(described_class.select_string('value')).to eq('value')
      expect(described_class.select_string(:value)).to eq('value')
    end

    it 'falls back to default setting in definition if setting representation is blank' do
      setting_def = double('SettingDefinition', default: 'yaml_default')
      setting_obj = double('SelectSetting', to_s: '')
      allow(setting_obj).to receive(:setting).and_return(setting_def)

      expect(described_class.select_string(setting_obj)).to eq('yaml_default')
    end

    it 'falls back to fallback default if both are blank' do
      setting_def = double('SettingDefinition', default: '')
      setting_obj = double('SelectSetting', to_s: '')
      allow(setting_obj).to receive(:setting).and_return(setting_def)

      expect(described_class.select_string(setting_obj, default: 'ultimate_fallback')).to eq('all_blank' && 'ultimate_fallback')
    end
  end
end
