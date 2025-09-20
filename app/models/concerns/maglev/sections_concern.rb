# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
module Maglev::SectionsConcern
  def prepare_sections(theme)
    # NOTE: pages defined in the theme definition
    # don't include the ids for sections/blocks
    self.sections ||= [] # NOTE: the self is mandatory here
    sections.each do |section|
      prepare_section(theme, section)
    end
  end

  def prepare_sections_translations(theme)
    return if sections_translations.blank?

    sections_translations.each_key do |locale|
      Maglev::I18n.with_locale(locale) do
        prepare_sections(theme)
      end
    end
  end

  def find_section_by_id(id)
    sections.find { |section| section['id'] == id }
  end

  def find_sections_by_type(type)
    sections&.find_all { |section| section['type'] == type } || []
  end

  def reorder_sections(sorted_section_ids, lock_version)
    self.lock_version = lock_version
    sections_translations_will_change!
    sections.sort! { |a, b| (sorted_section_ids.index(a['id'])) <=> (sorted_section_ids.index(b['id'])) }
  end

  def delete_section(section_id)
    sections_translations_will_change!
    sections.delete_if { |section| section['id'] == section_id }
  end

  def section_ids
    sections.map { |section| section['id'] }
  end

  def find_section_block_by_id(section_id, id)
    find_section_by_id(section_id)&.dig('blocks')&.find { |block| block['id'] == id }
  end

  private

  def prepare_section(theme, section)
    section['id'] ||= SecureRandom.urlsafe_base64(8)
    section['settings'] = prepare_settings(theme, section['type'], nil, section['settings'])
    section['blocks'] = (section['blocks'] || []).map do |block|
      prepare_block(theme, section['type'], block)
    end.flatten
    section
  end

  def prepare_block(theme, section_type, block)
    block['id'] ||= SecureRandom.urlsafe_base64(8)
    block['settings'] = prepare_settings(theme, section_type, block['type'], block['settings'])

    # the children key is accepted when the sections come from a theme preset
    children = (block.delete('children') || []).map do |nested_block|
      nested_block['parent_id'] = block['id']
      prepare_block(theme, section_type, nested_block)
    end
    [block, children].flatten
  end

  def prepare_settings(theme, section_type, block_type, settings)
    settings ||= [] # some blocks don't have settings

    # NOTE: in the theme definition file, we allow developers to declare
    # default content like this: { <setting_id_1>: <setting_value_1>, ..., <setting_id_n>: <setting_value_n> }
    settings = settings.map { |key, value| { id: key, value: value } } unless settings.is_a?(Array)

    settings.map do |setting|
      setting = setting.with_indifferent_access
      type = theme.find_setting!(section_type, block_type, setting['id'])
      setting.merge({ value: type.cast_value(setting['value']) })
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
