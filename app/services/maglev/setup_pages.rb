# frozen_string_literal: true

module Maglev
  # Create the default pages of the theme.
  # Called by the GenerateSite service.
  class SetupPages
    include Injectable

    dependency :persist_sections_content, class: Maglev::PersistSectionsContent

    argument :site
    argument :theme

    def call
      preset_pages&.map do |raw_attributes|
        create_resources(raw_attributes.with_indifferent_access)
      end
    end

    private

    def preset_pages
      theme&.pages
    end

    def create_resources(attributes)
      create_page(page_attributes(attributes)).tap do |page|
        create_sections_content(page, sections_content_attributes(attributes))
      end
    end

    def create_page(page_attributes)
      scoped_pages.create!(page_attributes)
    end

    def create_sections_content(page, sections_content)
      return if sections_content.blank?

      persist_sections_content.call(
        theme: theme,
        site: site,
        page: page,
        sections_content: sections_content
      )
    end

    def page_attributes(attributes)
      {
        title_translations: value_in_all_locales(attributes[:title]),
        path: value_in_all_locales(attributes[:path]),
        layout_id: attributes[:layout_id] || theme.layouts.first&.id
      }
    end

    def sections_content_attributes(attributes)
      attributes[:sections_content]&.keys&.map do |group_id|
        {
          id: group_id,
          sections_translations: value_in_all_locales(attributes.dig(:sections_content, group_id))
        }.with_indifferent_access
      end
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

    def scoped_pages
      ::Maglev::Page
    end
  end
end
