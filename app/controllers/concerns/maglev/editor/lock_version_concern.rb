# frozen_string_literal: true

module Maglev
  module Editor
    module LockVersionConcern
      extend ActiveSupport::Concern

      included do
        helper_method :source_lock_version
      end

      private

      def lock_source
        @section.site_scoped? ? maglev_site : current_maglev_page
      end

      def source_lock_version
        lock_source.lock_version || 0
      end

      def reload_lock_source
        lock_source.reload if @section.site_scoped?
      end
    end
  end
end
