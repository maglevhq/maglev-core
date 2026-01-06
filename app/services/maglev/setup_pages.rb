# frozen_string_literal: true

module Maglev
  # Create the default pages of the theme.
  # Called by the GenerateSite service.
  class SetupPages
    include Injectable

    dependency :create_page, class: Maglev::CreatePageService
    dependency :add_section, class: Maglev::Content::AddSectionService
    dependency :fetch_sections_store, class: Maglev::FetchSectionsStoreService

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
      page = create_page_record(page_attributes)

      throw ActiveRecord::StatementInvalid.new(page.errors.full_messages.join(', ')) if page.errors.any?

      add_sections(page, page_attributes) if page_attributes[:sections].present?

      page
    end

    def create_page_record(page_attributes)
      create_page.call(
        site: site,
        attributes: {
          layout_id: page_attributes.delete(:layout_id) || theme.default_layout_id,
          **attributes_in_all_locales(page_attributes)
        }
      )
    end

    def add_sections(page, page_attributes)
      fetch_layout(page.layout_id).groups.each do |group|
        store = find_store(page, group)
        sections_attributes = page_attributes.dig(:sections, group.id) # since it's theme related, we use the id (not the handle)

        next if sections_attributes.blank?

        add_sections_in_store_in_all_locales(store, sections_attributes)

        store.save!
      end
    end

    def add_sections_in_store_in_all_locales(store, sections_attributes)
      value_in_all_locales(sections_attributes).each do |locale, section_attributes|
        next if section_attributes.blank?

        Maglev::I18n.with_locale(locale) do
          add_sections_in_store(store, section_attributes)
        end
      end
    end

    def add_sections_in_store(store, sections_attributes)
      sections_attributes.each do |section_attributes|
        add_section_in_store(store, section_attributes)
      end
    end

    def add_section_in_store(store, attributes)
      add_section.call(
        site: site,
        theme: theme,
        store: store,
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
        og_image_url_translations: value_in_all_locales(attributes[:og_image_url])
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

    def find_store(page, layout_group)
      fetch_sections_store.call(
        page: page,
        handle: layout_group.handle, # since it's DB related, we use the handle (not the id)
        theme: theme,
        site: site
      )
    end

    def fetch_layout(layout_id)
      theme.find_layout(layout_id).tap do |layout|
        if layout.nil?
          raise Maglev::Errors::MissingLayout,
                "#{layout_id} layout doesn't exist in the theme."
        end
      end
    end
  end
end
