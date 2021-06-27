# frozen_string_literal: true

module Maglev
  module Admin
    class DashboardController < BaseController
      def index
        redirect_to admin_theme_path
      end
    end
  end
end
