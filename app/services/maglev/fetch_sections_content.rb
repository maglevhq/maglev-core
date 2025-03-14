# frozen_string_literal: true

module Maglev
  # Get the content of a store in a specific locale.
  # The content comes from the sections of the store.
  # Also replace the links by their real values based on the context (live editing or not).
  class FetchSectionsContent
    include Injectable
    include Maglev::FetchSectionsContent::TransformSectionConcern
    
    dependency :fetch_site
    dependency :fetch_theme
    dependency :fetch_collection_items
    dependency :fetch_static_pages
    dependency :get_page_fullpath

    argument :handle
    argument :locale, default: nil

    def call
      store = find_store
      [
        store.sections.map do |section|
          transform_section(section.dup)
        end.compact,
        store.lock_version
      ]
    end

    private

    def theme
      @theme ||= fetch_theme.call
    end

    def find_store
      scoped_store.find_or_initialize_by(handle: handle) do |store|
        store.sections = []
      end
    end

    def scoped_store
      Maglev::SectionsContentStore
    end
  end
end
