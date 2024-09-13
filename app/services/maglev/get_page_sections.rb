# frozen_string_literal: true

module Maglev
  # Get the content of a page in a specific locale.
  # The content comes from the sections of the page.
  # Also replace the links by their real values based on the context (live editing or not).
  class GetPageSections
    include Injectable
    include Maglev::GetPageSections::TransformTextConcern
    include Maglev::GetPageSections::TransformLinkConcern
    include Maglev::GetPageSections::TransformCollectionItemConcern

    dependency :fetch_site
    dependency :fetch_theme
    dependency :fetch_collection_items
    dependency :fetch_static_pages
    dependency :get_page_fullpath

    argument :page
    argument :page_sections, default: nil
    argument :locale, default: nil

    def call
      (page_sections || page.sections || []).map do |section|
        transform_section(section.dup)
      end.compact
    end

    protected

    def theme
      fetch_theme.call
    end

    def site
      fetch_site.call
    end

    def transform_section(section)
      definition = theme.sections.find(section['type'])

      raise_unknown_section_error(section['type']) unless definition

      transform_if_site_scoped(section, definition)
      transform_section_blocks(section['blocks'], definition)
      transform_section_settings(section, definition)

      section
    end

    # rubocop:disable Style/StringHashKeys
    def transform_if_site_scoped(section, definition)
      return unless definition.site_scoped?

      site_section = site.find_section(section['type'])

      return unless !page_sections && site_section

      # keep the same section id all over the pages
      section.merge!(
        'id' => site_section['id'],
        'settings' => site_section['settings'],
        'blocks' => site_section['blocks']
      )
    end
    # rubocop:enable Style/StringHashKeys

    def transform_section_blocks(blocks, definition)
      blocks.each do |block|
        block_definition = definition.blocks.find { |bd| bd.type == block['type'] }

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
end
