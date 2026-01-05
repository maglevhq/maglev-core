# frozen_string_literal: true

module Maglev
  module Content
    module PublishingStateConcern
      private

      # rubocop:disable Rails/SkipsModelValidations
      def touch_page(store)
        if store.page.present?
          store.page.touch
        else
          # found all the pages that share the same store handle and touch them
          # for instance, the `header` store could be shared by the `default` and `sidebar` layouts.
          # so, if we update the `header` store, we need to touch the `default` and `sidebar` pages.
          scoped_pages.where(layout_id: layout_ids_referencing_store_handle(store.handle)).touch_all
        end
      end
      # rubocop:enable Rails/SkipsModelValidations

      def layout_ids_referencing_store_handle(handle)
        theme.layouts.select do |layout|
          layout.groups.any? do |store|
            store.handle == handle
          end
        end.map(&:id)
      end

      def scoped_pages
        Maglev::Page
      end
    end
  end
end
