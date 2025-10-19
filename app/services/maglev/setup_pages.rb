# frozen_string_literal: true

module Maglev
  # Create the default pages of the theme.
  # Called by the GenerateSite service.
  class SetupPages
    include Injectable

    dependency :create_page, class: Maglev::CreatePageService
    dependency :add_section, class: Maglev::Content::AddSectionService

    argument :site
    argument :theme

    def call
      pages&.map do |page_attributes|
        create_page_with_sections(page_attributes)
      end
    end

    private

    def pages
      theme&.pages&.map(&:with_indifferent_access)
    end

    def create_page_with_sections(page_attributes)
      page = create_page.call(
        site: site,
        attributes: attributes_in_all_locales(page_attributes)
      )

      throw ActiveRecord::StatementInvalid.new(page.errors.full_messages.join(', ')) if page.errors.any?

      add_sections(page, page_attributes)

      page
    end

    def add_sections(page, page_attributes)
      value_in_all_locales(page_attributes[:sections]).each do |locale, sections_attributes|
        next if sections_attributes.blank?

        Maglev::I18n.with_locale(locale) do
          add_sections_in_page(page, sections_attributes)
        end
      end

      page.save!
      site.save!
    end

    def add_sections_in_page(page, sections_attributes)
      sections_attributes.each do |section_attributes|
        add_section_in_page(page, section_attributes)
      end
    end

    def add_section_in_page(page, attributes)
      add_section.call(
        theme: theme,
        site: site,
        page: page,
        section_type: attributes.fetch('type', nil),
        content: attributes,
        dry_run: true
      )
    end

    def attributes_in_all_locales(attributes)
      {
        title_translations: value_in_all_locales(attributes[:title]),
        path: value_in_all_locales(attributes[:path]),
        seo_title_translations: value_in_all_locales(attributes[:seo_title]),
        meta_description_translations: value_in_all_locales(attributes[:meta_description]),
        og_title_translations: value_in_all_locales(attributes[:og_title]),
        og_description_translations: value_in_all_locales(attributes[:og_description]),
        og_image_url_translations: value_in_all_locales(attributes[:og_image_url]),
        sections_translations: value_in_all_locales(attributes[:sections])
      }
    end

    def value_in_all_locales(value)
      if value.respond_to?(:each_pair)
        default_value = value[site.default_locale_prefix]
        fill_translations(default_value).merge(value)
      else
        fill_translations(value)
      end
    end

    def fill_translations(value)
      site.locale_prefixes.index_with { |_locale| value }
    end
  end
end
