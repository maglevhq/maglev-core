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
          format.html { redirect_to editor_root_path }
        end
      end      

      def handle_standard_error
        respond_to do |format|
          format.turbo_stream { render 'maglev/editor/shared/errors/standard_error' }
          format.html { redirect_to editor_root_path, alert: t('maglev.editor.errors.standard_error') }
        end
      end
    end
  end
end
