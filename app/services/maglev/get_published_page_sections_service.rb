# frozen_string_literal: true

module Maglev
  class GetPublishedPageSectionsService
    include Injectable
    include Maglev::GetPageSections::TransformSectionConcern

    dependency :fetch_site
    dependency :fetch_theme
    dependency :fetch_collection_items
    dependency :fetch_static_pages
    dependency :get_page_fullpath

    argument :page
    argument :locale, default: nil

    def call
      fetch_container_store(page).sections.map do |section|
        transform_section(section.dup)
      end.compact
    end

    protected

    def theme
      fetch_theme.call
    end

    def site
      fetch_site.call
    end

    def site_store
      @site_store ||= fetch_container_store(site)
    end

    def find_site_section(type)
      site_store.find_sections_by_type(type).first
    end

    def fetch_container_store(container)
      store = container.sections_content_stores.published.first
      raise Maglev::Errors::UnpublishedPage if store.blank?

      store
    end
  end
end
