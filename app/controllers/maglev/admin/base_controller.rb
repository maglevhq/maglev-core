# frozen_string_literal: true

module Maglev
  module Admin
    class BaseController < ::Maglev::ApplicationController
      layout 'maglev/admin/application'

      before_action :maglev_authenticate

      private

      def maglev_authenticate
        return unless Maglev.config.admin_username.present? && Maglev.config.admin_password.present?

        http_basic_authenticate_or_request_with name: Maglev.config.admin_username,
                                                password: Maglev.config.admin_password
      end
    end
  end
end
