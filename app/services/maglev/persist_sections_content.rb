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
      layout.groups.map do |group|
        [group.id, persist_group_content(group)]
      end.to_h.tap do
        persist_mirrored_sections(sections_content)
      end
    end

    private

    def theme
      @theme ||= fetch_theme.call
    end

    def layout
      @layout ||= fetch_layout(page.layout_id)
    end

    def persist_group_content(group)
      store = find_store(group.guess_store_handle(page))
      store.attributes = extract_store_attributes(group)
      store.save!
      store
    end

    def extract_store_attributes(group)
      (sections_content.find do |content_group|
        content_group['id'] == group.id
      end || {}).slice('sections', 'lock_version')
    end

    def find_store(handle)
      scoped_stores.find_or_create_by(handle: handle)
    end

    def fetch_layout(layout_id = nil)
      theme.find_layout(layout_id || page.layout_id).tap do |layout|
        raise Maglev::Errors::MissingLayout, "#{layout_id || page.layout_id} doesn't match a layout of the theme" if layout.nil?
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
