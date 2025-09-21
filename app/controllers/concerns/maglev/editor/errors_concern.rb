# frozen_string_literal: true

module Maglev
  module Editor
    module ErrorsConcern
      extend ActiveSupport::Concern

      included do
        rescue_from ::StandardError, with: :handle_standard_error unless Rails.env.local?

        rescue_from ActiveRecord::StaleObjectError, with: :handle_stale_object
        rescue_from Maglev::Errors::NotAuthorized, with: :handle_not_authorized
      end

      private

      def handle_stale_object
        respond_to do |format|
          format.turbo_stream { render 'maglev/editor/shared/errors/stale_object_error' }
          format.html { redirect_to editor_root_path, alert: 'Someone else has updated this content. Please reload.' }
        end
      end

      def handle_not_authorized
        respond_to do |format|
          format.turbo_stream { render 'maglev/editor/shared/errors/not_authorized_error' }
          format.html { redirect_to main_app.root_path, alert: 'You are not authorized to access this content.' }
        end
      end

      def handle_standard_error
        respond_to do |format|
          format.turbo_stream { render 'maglev/editor/shared/errors/standard_error' }
          format.html { redirect_to editor_root_path, alert: 'An error occurred. Please try again.' }
        end
      end
    end
  end
end
