# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
module Maglev::SectionsConcern
  def prepare_sections
    # NOTE: pages defined in the theme definition
    # don't include the ids for sections/blocks
    self.sections ||= [] # NOTE: the self is mandatory here
    sections.each do |section|
      prepare_section(section)
    end
  end

  def prepare_sections_translations
    return if sections_translations.blank?

    sections_translations.each_key do |locale|
      Maglev::I18n.with_locale(locale) do
        prepare_sections
      end
    end
  end

  def translate_sections_in(locale, source_locale)
    sections_translations[locale.to_s] ||= sections_translations[source_locale.to_s]
  end

  private

  def prepare_section(section)
    section['id'] ||= SecureRandom.urlsafe_base64(8)
    section['settings'] = prepare_settings(section['settings'])
    section['blocks'] = (section['blocks'] || []).map do |block|
      prepare_block(block)
    end.flatten
    section
  end

  def prepare_block(block)
    block['id'] ||= SecureRandom.urlsafe_base64(8)
    block['settings'] = prepare_settings(block['settings'])

    # the children key is accepted when the sections come from a theme preset
    children = (block.delete('children') || []).map do |nested_block|
      nested_block['parent_id'] = block['id']
      prepare_block(nested_block)
    end
    [block, children].flatten
  end

  def prepare_settings(settings)
    # NOTE: in the theme definition file, we allow developers to declare
    # default content like this: { <setting_id_1>: <setting_value_1>, ..., <setting_id_n>: <setting_value_n> }
    return settings if settings.is_a?(Array)

    settings.map { |key, value| { id: key, value: value } }
  end
end
# rubocop:enable Style/ClassAndModuleChildren
