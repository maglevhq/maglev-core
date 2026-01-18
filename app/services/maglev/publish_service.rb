# frozen_string_literal: true

module Maglev
  class PublishService
    include Injectable

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
      publish_container_sections!(site)
      publish_container_sections!(page)

      # copy the page information to the page published payload
      publish_page_information!
    end

    def publish_container_sections!(container)
      store = find_or_build_published_store(container)
      store.sections_translations = container.sections_translations
      store.save!
      # mark the container as published.
      # We need to add a delay to ensure that published_at will be posterior to the native updated_at of the container.
      container.update(published_at: Time.current + 0.2.seconds)
    end

    def find_or_build_published_store(container)
      container.sections_content_stores.find_or_initialize_by(container: container, published: true)
    end

    def publish_page_information!
      page.update_published_payload
      page.save!
    end
  end
end
