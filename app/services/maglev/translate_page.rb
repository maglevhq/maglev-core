# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
module Maglev
  # Translate a page into a given locale from a source locale.
  # This is a fake service that only copies the page attributes.
  class TranslatePage
    include Injectable

    dependency :fetch_site
    dependency :fetch_theme

    argument :page
    argument :locale
    argument :source_locale

    def call
      return nil unless page.persisted?

      @translations = {}

      translate_all!

      persist_changes!

      page
    end

    protected

    def site
      @site ||= fetch_site.call
    end

    def theme
      @theme ||= fetch_theme.call
    end

    # this is a third-step process because we need to group all the translations to process
    # in order to process them in parallel
    def translate_all!
      # 1. replace all the text to translatewith placeholders
      prepare_translate_page_attributes
      prepare_translate_all_sections # sections from page and site

      # 2. Translate all the placeholders in parallel
      async_translate

      # 3. replace the placeholders with the actual translations that has been processed in parallel
      replace_translations_in_page_attributes
      replace_translations_in_all_sections
    end

    def persist_changes!
      ActiveRecord::Base.transaction do
        site.save!
        page.save!
      end
    end

    def async_translate
      tasks = @translations.map do |id, text|
        Concurrent::Promises.future do
          { id => translate_text(text) }
        end
      end
      @translations = Concurrent::Promises.zip(*tasks).value!.reduce({}, :merge)
    end

    def translate_text(text)
      # @note: implement actual translation logic in a subclass
      # by default we just add the locale to the text
      text + " [#{locale.upcase}]"
    end

    # ===== Apply translations =====

    def replace_translations_in_page_attributes
      %w[title seo_title meta_description og_title og_description].each do |attr|
        page.translations_for(attr)[locale] = replace_translated_text(page.translations_for(attr)[locale])
      end
    end

    def replace_translations_in_all_sections
      [page, site].each do |source|
        source.sections_translations = JSON.parse(replace_translated_text(source.sections_translations.to_json))
      end
    end

    # ===== Prepare translations =====

    def prepare_translate_page_attributes
      %w[title seo_title meta_description og_title og_description].each do |attr|
        prepare_translate_page_attribute(attr)
      end
      # og_image_url is a special case because it's a URL, not content
      page.translations_for(:og_image_url)[locale] = page.translations_for(:og_image_url)[source_locale]
    end

    def prepare_translate_page_attribute(attr)
      page.translations_for(attr)[locale] = prepare_translate_text(page.translations_for(attr)[source_locale])
    end

    def prepare_translate_all_sections
      [page, site].each do |source|
        prepare_translate_sections(source)
      end
    end

    def prepare_translate_sections(source)
      # @note no need to translate if there are no sections in the source locale
      return if source.translations_for(:sections, source_locale).blank?

      # @note we don't want to overwrite existing translations
      return if source.translations_for(:sections, locale).present?

      source.sections_translations[locale] = clone_array(source.sections_translations[source_locale]).tap do |sections|
        sections.each { |section| prepare_translate_section(section) }
      end
    end

    def prepare_translate_section(section)
      definition = theme.sections.find(section['type'])
      prepare_translate_settings(section, definition)
      prepare_translate_section_blocks(section, definition)
    end

    def prepare_translate_settings(section_or_block, definition)
      return if definition.blank? # happens if the section/block is not defined in the theme

      section_or_block['settings'].each do |setting|
        type = definition.settings.find { |s| s.id == setting['id'] }&.type
        next if type.blank?

        setting['value'] = prepare_translate_setting_value(setting['value'], type)
      end
    end

    def prepare_translate_section_blocks(section, definition)
      section['blocks'].each do |block|
        block_definition = definition.blocks.find { |b| b.type == block['type'] }
        prepare_translate_settings(block, block_definition)
      end
    end

    def prepare_translate_setting_value(value, type)
      case type
      when 'text'
        prepare_translate_text(value)
      when 'link'
        value.merge(text: prepare_translate_text(value['text'])) if value.is_a?(Hash)
      when 'image'
        value.merge(alt: prepare_translate_text(value['alt'])) if value.is_a?(Hash)
      else
        value
      end
    end

    # NOTE: this method is a placeholder for the actual translation logic.
    def prepare_translate_text(text)
      return text if text.blank?

      id = SecureRandom.uuid
      @translations[id] = text

      "--#{id}--"
    end

    def replace_translated_text(text)
      return text if text.blank?

      text.gsub(/--([a-f0-9-]{36})--/) do |_match|
        @translations[::Regexp.last_match(1)].to_json.gsub(/^\"/, '').gsub(/\"$/, '')
      end
    end

    def clone_array(array)
      Marshal.load(Marshal.dump(array || []))
    end
  end
end
# rubocop:enable Metrics/ClassLength
