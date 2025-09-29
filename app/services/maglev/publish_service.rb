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
      store = container.sections_content_stores.find_or_initialize_by(container: container, published: true)
      store.sections_translations = container.sections_translations
      store.save!
    end
  end
end
