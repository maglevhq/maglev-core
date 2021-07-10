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

  def build_default_settings_content(custom_settings = nil)
    (custom_settings || settings).map do |definition|
      { id: definition.id, value: definition.build_default_content }
    end
  end

  def build_default_block_content
    return [] if blocks.blank?

    blocks.map do |block|
      3.times.to_a.map do
        {
          type: block.type,
          settings: build_default_settings_content(block.settings)
        }
      end
    end.flatten
  end
end
# rubocop:enable Style/ClassAndModuleChildren
