# frozen_string_literal: true

module Maglev
  class HasUnpublishedChanges
    include Injectable

    argument :site
    argument :page
    argument :theme

    def call
      page.need_to_be_published? || any_store_needs_publishing?
    end

    private

    def any_store_needs_publishing?
      scoped_stores
        .where(handle: global_handles, maglev_page_id: nil)
        .pluck(:handle, :published, :updated_at)
        .group_by(&:first)
        .any? { |_, records| draft_newer_than_published?(records) }
    end

    # Each record is a [handle, published, updated_at] tuple
    # Example:
    # [
    #   ['header', false, '2026-02-11 10:00:00'],
    #   ['header', true, '2026-02-11 09:59:00'],
    # ]
    def draft_newer_than_published?(records)
      draft = records.find { |_, published, _| published == false }
      published = records.find { |_, published, _| published == true }
      draft && (published.nil? || draft[2] > published[2])
    end

    def global_handles
      layout.groups.reject(&:page_scoped?).map(&:handle) +
        [Maglev::SectionsContentStore::SITE_HANDLE]
    end

    def layout
      theme.find_layout(page.layout_id)
    end

    def scoped_stores
      Maglev::SectionsContentStore
    end
  end
end
