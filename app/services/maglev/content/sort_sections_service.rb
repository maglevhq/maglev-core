# frozen_string_literal: true

module Maglev
  module Content
    class SortSectionsService
      include Injectable
      include Maglev::Content::HelpersConcern

      dependency :fetch_theme
      dependency :fetch_site

      argument :store
      argument :section_ids
      argument :lock_version

      def call
        store.lock_version = lock_version

        store.sections_translations_will_change!
        store.reorder_sections(section_ids)
        store.save!        
      end
    end
  end
end
