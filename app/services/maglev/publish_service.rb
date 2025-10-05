# frozen_string_literal: true

module Maglev
  class PublishService
    include Injectable

    argument :site
    argument :page

    def call
      ActiveRecord::Base.transaction do
        publish_container_sections!(site)
        publish_container_sections!(page)
      end
      true
    end

    private

    def publish_container_sections!(container)
      store = find_or_build_published_store(container)
      store.sections_translations = container.sections_translations
      store.save!
    end

    def find_or_build_published_store(container)
      container.sections_content_stores.find_or_initialize_by(container: container, published: true)
    end
  end
end
