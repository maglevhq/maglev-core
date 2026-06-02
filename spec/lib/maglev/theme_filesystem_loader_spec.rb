# frozen_string_literal: true

require 'rails_helper'

describe Maglev::ThemeFilesystemLoader do
  let(:fetch_section_screenshot_path) { ->(theme:, section:, absolute:) { '/path/to/screenshot.png' } }
  let(:loader) { described_class.new(fetch_section_screenshot_path) }

  describe '#call' do
    # rubocop:disable Lint/UnusedBlockArgument
    let(:fetch_section_screenshot_path) { ->(theme:, section:, absolute:) { path } }
    # rubocop:enable Lint/UnusedBlockArgument

    subject { described_class.new(fetch_section_screenshot_path).call(Pathname.new(path)) }

    context 'There are 2 sections with the same id in different categories' do
      let(:path) { File.expand_path('./spec/fixtures/themes/theme_with_sections_with_same_id') }

      it 'raises a DuplicateSectionDefinition error' do
        expect { subject }.to raise_error(Maglev::Errors::DuplicateSectionDefinition)
      end
    end
  end

  describe '#build_section' do
    let(:theme) { double('Maglev::Theme', id: 'my_theme') }

    it 'automatically injects spacing settings for sections other than spacer' do
      attributes = { 'name' => 'Hero', 'settings' => [] }
      section = loader.send(:build_section, theme, 'hero', attributes)

      setting_ids = section.settings.map(&:id)
      expect(setting_ids).to include('spacing_top', 'spacing_bottom', 'spacing_size')
    end

    it 'does not inject spacing settings for spacer section' do
      attributes = { 'name' => 'Spacer', 'settings' => [] }
      section = loader.send(:build_section, theme, 'spacer', attributes)

      setting_ids = section.settings.map(&:id)
      expect(setting_ids).not_to include('spacing_top', 'spacing_bottom', 'spacing_size')
    end

    it 'does not inject spacing settings if spacing_top is already defined' do
      attributes = {
        'name' => 'Hero',
        'settings' => [
          { 'id' => 'spacing_top', 'type' => 'checkbox', 'label' => 'Custom top spacing' }
        ]
      }
      section = loader.send(:build_section, theme, 'hero', attributes)

      setting_ids = section.settings.map(&:id)
      # Should only have the pre-defined one, not the duplicated one from SPACING_SETTINGS
      spacing_top_settings = section.settings.select { |s| s.id == 'spacing_top' }
      expect(spacing_top_settings.length).to eq(1)
      expect(spacing_top_settings.first.label).to eq('Custom top spacing')
    end

    it 'injects button_type and button_variant next to button_text' do
      attributes = {
        'name' => 'Hero',
        'settings' => [
          { 'id' => 'button_text', 'type' => 'text', 'label' => 'Button text' },
          { 'id' => 'other_setting', 'type' => 'text', 'label' => 'Other' }
        ]
      }
      section = loader.send(:build_section, theme, 'hero', attributes)

      setting_ids = section.settings.map(&:id)
      expect(setting_ids).to include('button_type', 'button_variant')

      # Check correct ordering
      idx_text = setting_ids.index('button_text')
      idx_type = setting_ids.index('button_type')
      idx_variant = setting_ids.index('button_variant')

      expect(idx_type).to eq(idx_text + 1)
      expect(idx_variant).to eq(idx_type + 1)
    end

    it 'injects button_type and button_variant next to button_link if button_text is not present' do
      attributes = {
        'name' => 'Hero',
        'settings' => [
          { 'id' => 'button_link', 'type' => 'link', 'label' => 'Button link' }
        ]
      }
      section = loader.send(:build_section, theme, 'hero', attributes)

      setting_ids = section.settings.map(&:id)
      expect(setting_ids).to include('button_type', 'button_variant')

      idx_link = setting_ids.index('button_link')
      idx_type = setting_ids.index('button_type')
      idx_variant = setting_ids.index('button_variant')

      expect(idx_type).to eq(idx_link + 1)
      expect(idx_variant).to eq(idx_type + 1)
    end
  end
end
