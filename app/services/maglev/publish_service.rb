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
              
      # copy the page information to the page published payload
      publish_page_information!

      mark_site_and_page_as_published!
    end
    
    def publish_stores!
      layout_stores.each do |definition|
        scoped_stores.find_or_initialize_by(handle: definition.id, published: true, page: definition.page_scoped? ? page : nil) do |store|
          store.sections_translations = store.sections_translations
          store.save!
        end
      end
    end

    def publish_site_scoped_store!
      scoped_stores.find_or_initialize_by(handle: ::Maglev::SectionsContentStore::SITE_HANDLE, published: true, page: nil) do |store|
        store.sections_translations = site.sections_translations
        store.save!
      end
    end

    def mark_site_and_page_as_published!
      # We need to add a delay to ensure that their published_at will be posterior to the native updated_at of the store.
      site.update(published_at: Time.current + 0.2.seconds)
      page.update(published_at: Time.current + 0.2.seconds)
    end

    def layout_stores
      theme.find_layout(page.layout_id).groups
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
