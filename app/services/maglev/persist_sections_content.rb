# frozen_string_literal: true

module Maglev
  class PersistSectionsContent
    include Injectable
    include Maglev::MirroredSectionsConcern

    dependency :fetch_theme

    argument :site
    argument :page
    argument :sections_content
    argument :theme, default: nil

    def call
      ActiveRecord::Base.transaction do
        unsafe_call
      end
    end

    def unsafe_call
      content = layout.groups.map do |group|
        [group.id, persist_group_content(group, extract_store_attributes(group))]
      end.to_h

      persist_mirrored_sections(sections_content)

      content
    end

    private

    def theme
      @theme ||= fetch_theme.call
    end

    def site
      @site ||= fetch_site.call
    end

    def layout
      @layout ||= fetch_layout(page.layout_id)
    end

    def persist_group_content(group, attributes)
      store = find_store(group, page)
      store.attributes = attributes

      if attributes.key?('sections_translations')
        store.prepare_sections_translations(theme)
      else
        store.prepare_sections(theme)
      end

      store.save!
      store
    end

    def extract_store_attributes(group)
      (sections_content.find do |content_group|
        content_group['id'] == group.id
      end || {}).slice('sections', 'sections_translations', 'lock_version')
    end

    def find_store(group, page)
      scoped_stores.find_or_create_by(handle: group.guess_store_handle(page)) do |store|
        store.page = page if group.page_store?
        store.sections_translations = site.locale_prefixes.index_with { |_locale| [] }
      end
    end

    def fetch_layout(layout_id = nil)
      theme.find_layout(layout_id || page.layout_id).tap do |layout|
        if layout.nil?
          raise Maglev::Errors::MissingLayout,
                "#{layout_id || page.layout_id} doesn't match a layout of the theme"
        end
      end
    end

    def scoped_stores
      Maglev::SectionsContentStore
    end

    def scoped_pages
      Maglev::Page
    end
  end
end
