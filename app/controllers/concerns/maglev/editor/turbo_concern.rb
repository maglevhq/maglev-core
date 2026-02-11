# frozen_string_literal: true

module Maglev
  module Editor
    module TurboConcern
      extend ActiveSupport::Concern

      included do
        helper_method :maglev_disable_turbo_cache?
      end

      private

      def maglev_disable_turbo_cache
        @maglev_disable_turbo_cache = true
      end

      def maglev_disable_turbo_cache?
        !!@maglev_disable_turbo_cache
      end

      def ensure_turbo_frame_request
        return if turbo_frame_request?

        redirect_to editor_root_path
      end
    end
  end
end
