# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
module Maglev::Section::ContentConcern
  def build_default_content
    {
      id: SecureRandom.urlsafe_base64(8),
      type: id,
      settings: build_default_settings_content,
      blocks: build_default_blocks_content
    }
  end

  def build_block_content_for(block_type, parent_id = nil)
    block_definition = blocks.find(block_type)

    raise Maglev::Errors::UnknownBlock unless block_definition

    {
      id: SecureRandom.urlsafe_base64(8),
      type: block_definition.type,
      settings: fallback_build_default_settings_content(block_definition.settings),
      parent_id: parent_id
    }.compact_blank
  end

  private

  def build_default_settings_content(source = nil, custom_settings = nil)
    return fallback_build_default_settings_content unless sample

    (custom_settings || settings).map do |definition|
      source ||= sample[:settings]
      value = definition.build_default_content(source[definition.id.to_sym])
      { id: definition.id, value: value }
    end
  end

  def build_default_blocks_content
    return fallback_build_default_blocks_content unless sample

    blocks_content = {}

    sample[:blocks]&.each do |block|
      build_default_block_content(block, blocks_content, nil)
    end

    blocks_content.values.compact
  end

  # block is a hash representing a block content from a section "sample" attribute
  def build_default_block_content(block, memo, parent_id = nil)
    content = core_build_default_block_content(block, parent_id)
    return unless content

    memo[content[:id]] = content

    (block[:children] || []).each do |child_block|
      build_default_block_content(child_block, memo, content[:id])
    end
  end

  def core_build_default_block_content(block, parent_id = nil)
    settings = blocks.find(block[:type])&.settings
    return unless settings

    content = {
      id: SecureRandom.urlsafe_base64(8),
      type: block[:type],
      settings: build_default_settings_content(block[:settings], settings)
    }

    content[:parent_id] = parent_id if parent_id

    content
  end

  def fallback_build_default_settings_content(custom_settings = nil)
    (custom_settings || settings).map do |definition|
      { id: definition.id, value: definition.build_default_content }
    end
  end

  def fallback_build_default_blocks_content
    return [] if blocks.blank?

    blocks.map do |block|
      3.times.to_a.map do
        {
          type: block.type,
          settings: fallback_build_default_settings_content(block.settings)
        }
      end
    end.flatten
  end
end
# rubocop:enable Style/ClassAndModuleChildren
