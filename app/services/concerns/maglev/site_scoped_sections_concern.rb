# frozen_string_literal: true

module Maglev
  module SiteScopedSectionsConcern
    private

    def persist_site_scoped_sections(sections_content)
      sections_content.map { |group| group['sections'] }.flatten.compact.find do |section|
        next unless site_scoped_section?(section)

        update_site_scoped_section(section)
      end
      site_scoped_store.save!
    end

    def update_site_scoped_section(section)
      store_section = site_scoped_store.find_section_by_type(section['type'])

      if store_section.nil?
        site_scoped_store.sections << section
      else
        site_scoped_store.replace_section_content(store_section, section)
      end
    end

    def site_scoped_section?(section)
      theme.sections.find(section['type']).site_scoped?
    end

    def replace_content_from_site_scoped_sections(store)
      store.sections.each do |section|
        next unless site_scoped_section?(section)

        store_section = site_scoped_store.find_section_by_type(section['type'])
        next unless store_section

        # keep the same section id all over the pages
        store.replace_section(section, store_section)

        # site scoped sections have the same lock version as the site scoped store
        section['lock_version'] = site_scoped_store.lock_version
      end
    end

    def site_scoped_store
      @site_scoped_store ||= scoped_stores.find_or_create_by(
        handle: ::Maglev::SectionsContentStore::SITE_HANDLE,
        published: published
      ) do |store|
        store.sections_translations = site.locale_prefixes.index_with { |_locale| [] }
      end
    end
  end
end
