# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
module Maglev::Section::ContentConcern
  def build_default_content
    {
      id: SecureRandom.urlsafe_base64(8),
      type: id,
      settings: build_default_settings_content,
      blocks: build_default_block_content
    }
  end

  private

  def build_default_settings_content(source = nil, custom_settings = nil)
    return build_default_settings_content_fallback unless sample

    (custom_settings || settings).map do |definition|
      source ||= sample[:settings]
      value = definition.build_default_content(source[definition.id.to_sym])
      { id: definition.id, value: value }
    end
  end

  def build_default_block_content
    return build_default_block_content_fallback unless sample

    sample[:blocks].map do |block|
      settings = blocks.find { |bd| bd.type == block[:type] }&.settings
      next unless settings

      {
        type: block[:type],
        settings: build_default_settings_content(block[:settings], settings)
      }
    end.compact
  end

  def build_default_settings_content_fallback(custom_settings = nil)
    (custom_settings || settings).map do |definition|
      { id: definition.id, value: definition.build_default_content }
    end
  end

  def build_default_block_content_fallback
    return [] if blocks.blank?

    blocks.map do |block|
      3.times.to_a.map do
        {
          type: block.type,
          settings: build_default_settings_content_fallback(block.settings)
        }
      end
    end.flatten
  end
end
# rubocop:enable Style/ClassAndModuleChildren
