# frozen_string_literal: true

module Maglev
  # Get the content of a store in a specific locale.
  # The content comes from the sections of the store.
  # Also replace the links by their real values based on the context (live editing or not).
  class FetchSectionsContentService
    include Injectable
    include Maglev::GetPageSections::TransformSectionConcern
    include Maglev::MirroredSectionsConcern
    include Maglev::SiteScopedSectionsConcern

    dependency :fetch_site
    dependency :fetch_theme
    dependency :fetch_collection_items
    dependency :fetch_static_pages
    dependency :get_page_fullpath

    argument :handle
    argument :page, default: nil
    argument :published, default: false
    argument :locale, default: nil

    def call
      store = published && page ? find_published_store! : find_or_build_store
      [transform_sections(store), store.lock_version]
    end

    private

    def theme
      @theme ||= fetch_theme.call
    end

    def site
      @site ||= fetch_site.call
    end

    def find_or_build_store
      scoped_stores.find_or_initialize_by(handle: handle, page: page, published: published) do |store|        
        store.sections_translations = site.locale_prefixes.index_with { |_locale| [] }
      end
    end

    def find_published_store!
      # by definition, a page is unpublished if the page store hasn't been created yet
      scoped_stores.find_by(handle: handle, page: page, published: true).tap do |store|        
        raise Maglev::Errors::UnpublishedPage if store.nil?
      end
    end

    def transform_sections(store)
      # look for mirrored sections / global site scoped sections and get the fresh content
      replace_content_from_mirror_sections(store)
      replace_content_from_site_scoped_sections(store)

      store.sections.map do |section|
        transform_section(section.dup)
      end.compact
    end

    def fetch_layout(layout_id = nil)
      theme.find_layout(layout_id || page.layout_id).tap do |layout|
        if layout.nil?
          raise Maglev::Errors::MissingLayout,
                "#{layout_id || page.layout_id} doesn't match a layout of the theme"
        end
      end
    end

    def find_store(group, page)
      scoped_stores.find_by(handle: group.id, page: page, published: published)
    end

    def scoped_stores
      Maglev::SectionsContentStore
    end

    def scoped_pages
      Maglev::Page
    end
  end
end
