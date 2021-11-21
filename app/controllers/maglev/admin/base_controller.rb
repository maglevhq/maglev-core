# frozen_string_literal: true

module Maglev
  module Admin
    class BaseController < ::Maglev::ApplicationController
      layout 'maglev/admin/application'

      before_action :maglev_authenticate

      private

      def maglev_authenticate
        username = maglev_config.admin_username
        password = maglev_config.admin_password
        return if !username || !password

        redirect_to main_app.root_path unless authenticate_with_http_basic { |u, p| username == u && password == p }
      end
    end
  end
end
