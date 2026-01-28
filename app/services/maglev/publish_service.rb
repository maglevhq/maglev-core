# frozen_string_literal: true

module Maglev
  class PublishService
    include Injectable

    argument :theme
    argument :site
    argument :page

    def call
      ActiveRecord::Base.transaction do
        unsafe_call
      end
      true
    end

    private

    def unsafe_call
      # copy content from the containers (site and page) to the published stores
      publish_stores!
      publish_site_scoped_store!

      mark_site_and_page_as_published!

      # copy the page information to the page published payload
      publish_page_information!
    end

    def publish_stores!
      layout_stores.each do |definition|
        publish_store(definition.id, definition.page_scoped? ? page : nil)
      end
    end

    def publish_site_scoped_store!
      publish_store(::Maglev::SectionsContentStore::SITE_HANDLE)
    end

    def publish_store(handle, page = nil)
      unpublished_store = fetch_unpublished_store(handle, page)
      sections_translations = unpublished_store&.sections_translations.presence || default_sections_translations

      published_store = scoped_stores.find_or_initialize_by(published: true, handle: handle, page: page)
      published_store.sections_translations = sections_translations
      published_store.save!
    end

    def mark_site_and_page_as_published!
      # We need to add a delay to ensure that their published_at will be posterior
      # to the native updated_at of the store.
      site.update(published_at: Time.current + 0.2.seconds)
      page.update(published_at: Time.current + 0.2.seconds)
    end

    def fetch_unpublished_store(handle, page = nil)
      scoped_stores.unpublished.find_by(handle: handle, page: page)
    end

    def layout_stores
      theme.find_layout(page.layout_id).groups
    end

    def default_sections_translations
      site.locale_prefixes.index_with { |_locale| [] }
    end

    def scoped_stores
      Maglev::SectionsContentStore
    end

    def publish_page_information!
      page.update_published_payload
      page.save!
    end
  end
end
