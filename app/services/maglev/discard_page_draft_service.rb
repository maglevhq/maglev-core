# frozen_string_literal: true

module Maglev
  class DiscardPageDraftService
    include Injectable

    argument :theme
    argument :site
    argument :page

    def call
      ActiveRecord::Base.transaction do
        revert_stores!
        revert_site_scoped_store!
        revert_page_information!
        update_updated_at!
      end
      true
    end

    private

    def revert_stores!
      layout_stores.each do |definition|
        revert_store(definition.handle, definition.page_scoped? ? page : nil)
      end
    end

    def revert_site_scoped_store!
      revert_store(::Maglev::SectionsContentStore::SITE_HANDLE)
    end

    def revert_store(handle, page = nil)
      published_store = find_published_store(handle, page)
      raise Maglev::Errors::UnpublishedPage if published_store.blank?

      unpublished_store = find_or_initialize_unpublished_store(handle, page)
      unpublished_store.sections_translations = published_store.sections_translations
      unpublished_store.save!
    end

    def find_published_store(handle, page = nil)
      scoped_stores.published.find_by(handle: handle, maglev_page_id: page&.id)
    end

    def find_or_initialize_unpublished_store(handle, page = nil)
      scoped_stores.find_or_initialize_by(handle: handle, maglev_page_id: page&.id, published: false) do |store|
        store.sections_translations = site.locale_prefixes.index_with { |_locale| [] }
      end
    end

    def layout_stores
      theme.find_layout(page.layout_id).groups
    end

    def scoped_stores
      Maglev::SectionsContentStore
    end

    def revert_page_information!
      page.apply_published_payload
      page.save!
    end

    def update_updated_at!
      # Update updated_at to be before published_at to mark as up-to-date
      # rubocop:disable Rails/SkipsModelValidations
      page.update_column(:updated_at, page.published_at) if page.published_at.present?
      # rubocop:enable Rails/SkipsModelValidations
    end
  end
end
