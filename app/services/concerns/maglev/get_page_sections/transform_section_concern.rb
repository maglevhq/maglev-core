# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
module Maglev::GetPageSections::TransformSectionConcern
  extend ActiveSupport::Concern

  included do
    include Maglev::GetPageSections::TransformTextConcern
    include Maglev::GetPageSections::TransformLinkConcern
    include Maglev::GetPageSections::TransformCollectionItemConcern
  end

  protected

  def transform_section(section)
    definition = theme.sections.find(section['type'])

    raise_unknown_section_error(section['type']) unless definition

    # transform_if_site_scoped(section, definition)
    transform_section_blocks(section['blocks'], definition)
    transform_section_settings(section, definition)

    section
  end

  # def transform_if_site_scoped(section, definition)
  #   return unless definition.site_scoped?

  #   site_section = find_site_section(section['type'])

  #   return unless site_section

  #   # keep the same section id all over the pages
  #   section.merge!(
  #     'id' => site_section['id'],
  #     'settings' => site_section['settings'],
  #     'blocks' => site_section['blocks'],
  #     'lock_version' => site_section['lock_version']
  #   )
  # end
  def transform_section_blocks(blocks, definition)
    blocks.each do |block|
      block_definition = definition.blocks.find(block['type'])

      next unless block_definition

      transform_section_settings(block, block_definition)
    end
  end

  def transform_section_settings(section, definition)
    remove_unused_settings(section, definition)

    definition.settings.each do |setting|
      section_setting = find_section_setting(section, setting.id)

      next unless section_setting

      transform_content_setting(section_setting, setting)
    end
  end

  def transform_content_setting(content, setting)
    case setting.type
    when 'link'
      transform_link_content_setting(content, setting)
    when 'text'
      transform_text_content_setting(content, setting)
    when 'collection_item'
      transform_collection_item_content_setting(content, setting)
    end
  end

  def remove_unused_settings(section, definition)
    section['settings'].select! do |setting|
      definition.settings.any? do |definition_setting|
        definition_setting.id == setting['id']
      end
    end
  end

  def find_section_setting(section, setting_id)
    # NOTE: works for both sections and blocks
    section['settings'].find { |setting| setting['id'] == setting_id }
  end

  def raise_unknown_section_error(type)
    raise ::Maglev::Errors::UnknownSection, "Unknown Maglev section type (#{type})" unless Rails.env.production?

    Rails.logger.warn "[#{theme.id}] unknown Maglev section type (#{type})"
  end
end
# rubocop:enable Style/ClassAndModuleChildren
