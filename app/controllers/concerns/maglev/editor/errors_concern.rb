# frozen_string_literal: true

module Maglev
  module Editor
    module ErrorsConcern
      extend ActiveSupport::Concern

      included do
        rescue_from ActiveRecord::StaleObjectError, with: :handle_stale_object
      end

      private

      def handle_stale_object
        respond_to do |format|
          format.turbo_stream { render 'maglev/editor/shared/stale_object_error' }
          format.html { redirect_to request.path, alert: 'Someone else has updated this content. Please reload.' }
        end
      end
    end
  end
end
