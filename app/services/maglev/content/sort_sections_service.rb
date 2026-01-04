# frozen_string_literal: true

module Maglev
  module Content
    class SortSectionsService
      include Injectable
      include Maglev::Content::HelpersConcern
      include Maglev::Content::PublishingStateConcern

      dependency :fetch_theme
      dependency :fetch_site

      argument :store
      argument :section_ids
      argument :lock_version

      def call
        ActiveRecord::Base.transaction do
          unsafe_call
        end
      end

      private

      def unsafe_call
        sort_sections!.tap { touch_page(store) }
      end

      def sort_sections!
        store.lock_version = lock_version

        store.sections_translations_will_change!
        store.reorder_sections(section_ids)
        store.save!
      end
    end
  end
end
