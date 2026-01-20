# frozen_string_literal: true

module Maglev
  class RevertPageChangesService
    include Injectable

    argument :site
    argument :page

    def call
      ActiveRecord::Base.transaction do
        revert_container_sections!(site)
        revert_container_sections!(page)
      end
      true
    end

    private

    def revert_container_sections!(container)
      store = find_published_store(container)

      raise Maglev::Errors::UnpublishedPage if store.blank?

      container.sections_translations_will_change!
      container.sections_translations = store.sections_translations
      container.save!

      # Update updated_at to be before published_at to mark as up-to-date
      # rubocop:disable Rails/SkipsModelValidations
      container.update_column(:updated_at, container.published_at - 0.1.seconds) if container.published_at.present?
      # rubocop:enable Rails/SkipsModelValidations
    end

    def find_published_store(container)
      container.sections_content_stores.published.first
    end
  end
end
