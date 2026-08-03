# frozen_string_literal: true

module Maglev
  module Editor
    module LockVersionConcern
      extend ActiveSupport::Concern

      included do
        helper_method :source_lock_version
      end

      private

      def source_lock_version
        sections_store.lock_version || 0
      end
    end
  end
end
