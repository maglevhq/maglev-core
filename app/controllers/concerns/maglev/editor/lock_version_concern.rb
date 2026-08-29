# frozen_string_literal: true

module Maglev
  module Editor
    module LockVersionConcern
      extend ActiveSupport::Concern

      included do
        helper_method :source_lock_version
      end

      private

      # NOTE: we can't always rely on the lock version of the store the section was fetched
      # from: a site scoped section is listed in a layout store (its "slot") but its content
      # lives in the global site scoped store, which is what the content services update.
      # Fortunately, the sections content fetcher stamps each section with the lock version
      # of the store its content actually comes from, so we use it whenever possible.
      def source_lock_version
        @section ? @section.lock_version : (sections_store.lock_version || 0)
      end
    end
  end
end
