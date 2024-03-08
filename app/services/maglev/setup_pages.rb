# frozen_string_literal: true

module Maglev
  # Create the default pages of the theme.
  # Called by the GenerateSite service.
  class SetupPages
    include Injectable

    dependency :persist_page, class: Maglev::PersistPage

    argument :site
    argument :theme

    def call
      pages&.map do |page_attributes|
        create_page(
          attributes_in_all_locales(page_attributes.with_indifferent_access)
        )
      end
    end

    private

    def pages
      theme&.pages
    end

    def create_page(page_attributes)
      persist_page.call(
        site: site,
        site_attributes: site_attributes_from(page_attributes),
        theme: theme,
        page: Maglev::Page.new,
        page_attributes: page_attributes
      )
    end

    def site_attributes_from(page_attributes)
      if page_attributes.include?(:sections_translations)
        { sections_translations: site_sections_translations(page_attributes) }
      else
        { sections: select_site_scoped_sections(page_attributes[:sections]) }
      end.compact || {}
    end

    def site_sections_translations(page_attributes)
      sections_translations = page_attributes[:sections_translations].transform_values do |sections|
        select_site_scoped_sections(sections)
      end
      sections_translations.any? { |_, sections| sections.blank? } ? nil : sections_translations
    end

    def attributes_in_all_locales(attributes)
      {
        title_translations: value_in_all_locales(attributes[:title]),
        sections_translations: value_in_all_locales(attributes[:sections]),
        path: value_in_all_locales(attributes[:path])
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

    def select_site_scoped_sections(sections)
      (sections || []).find_all do |section|
        definition = theme.sections.find(section['type'])

        raise "[Maglev] Unknown section type: #{section['type']}" unless definition

        definition.site_scoped?
      end
    end
  end
end
