# frozen_string_literal: true

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

      translate_page!
    end

    private

    def site
      @site ||= fetch_site.call
    end

    def theme
      @theme ||= fetch_theme.call
    end

    protected

    def translate_page!
      translate_page_attributes
      translate_sections

      ActiveRecord::Base.transaction do
        site.save!
        page.save!
      end

      page
    end

    def translate_page_attributes
      %w[title seo_title meta_description og_title og_description].each do |attr|
        translate_page_attribute(attr)
      end
      # og_image_url is a special case because it's a URL, not content
      page.translations_for(:og_image_url)[locale] = page.translations_for(:og_image_url)[source_locale]
    end

    def translate_page_attribute(attr)
      page.translations_for(attr)[locale] = translate_text(page.translations_for(attr)[source_locale])
    end

    def translate_sections
      if site.sections_translations[locale].blank?
        site.sections_translations[locale] = clone_array(site.sections_translations[source_locale]).tap do |sections|
          sections.each { |section| translate_section(section) }
        end
      end

      page.sections_translations[locale] = clone_array(page.sections_translations[source_locale]).tap do |sections|
        sections.each { |section| translate_section(section) }
      end
    end

    def translate_section(section)
      definition = theme.sections.find(section['type'])
      translate_settings(section, definition)
      translate_section_blocks(section, definition)
    end

    def translate_settings(section_or_block, definition)
      section_or_block['settings'].each do |setting|
        type = definition.settings.find { |s| s.id == setting['id'] }&.type
        next if type.blank?

        setting['value'] = translate_setting_value(setting['value'], type)
      end
    end

    def translate_section_blocks(section, definition)
      section['blocks'].each do |block|
        block_definition = definition.blocks.find { |b| b.type == block['type'] }
        translate_settings(block, block_definition)
      end
    end

    def translate_setting_value(value, type)
      case type
      when 'text'
        translate_text(value)
      when 'link'
        value.merge(text: translate_text(value['text'])) if value.is_a?(Hash)
      when 'image'
        value.merge(alt: translate_text(value['alt'])) if value.is_a?(Hash)
      else
        value
      end
    end

    # NOTE: this method is a placeholder for the actual translation logic.
    def translate_text(text)
      return nil if text.blank?

      text + " [#{locale.upcase}]"
    end

    def clone_array(array)
      Marshal.load(Marshal.dump(array || []))
    end
  end

  # def theme
  #   @theme ||= fetch_theme.call
  # end

  # def site
  #   @site ||= fetch_site.call
  # end
end
