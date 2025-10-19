# frozen_string_literal: true

module Maglev
  module Editor
    module ErrorsConcern
      extend ActiveSupport::Concern

      included do
        around_action :handle_editor_errors

        rescue_from ActiveRecord::StaleObjectError, with: :handle_stale_object
      end

      private

      def handle_stale_object
        respond_to do |format|
          format.turbo_stream { render 'maglev/editor/shared/errors/stale_object_error' }
          format.html { redirect_to editor_root_path }
        end
      end

      def handle_editor_errors
        yield
      rescue Maglev::Errors::NotAuthorized
        raise # Let the main app handle this one
      rescue StandardError => e
        track_maglev_error(e)
        respond_to do |format|
          format.turbo_stream { render 'maglev/editor/shared/errors/standard_error', status: :internal_server_error }
          format.html { redirect_to editor_root_path, alert: t('maglev.editor.errors.standard_error') }
        end
      end

      def track_maglev_error(error)
        Rails.logger.error "[Maglev] Error: #{error.message}"
        Rails.logger.error error.backtrace.join("\n")
      end
    end
  end
end
