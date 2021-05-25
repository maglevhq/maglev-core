# frozen_string_literal: true

module Maglev
  class DashboardController < ::Maglev::ApplicationController
    def index
      @theme = services.fetch_theme.call
    end
  end
end
