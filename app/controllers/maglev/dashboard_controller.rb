# frozen_string_literal: true

module Maglev
  class DashboardController < ApplicationController
    def index
      @themes = [::Maglev::Theme.default]
    end
  end
end
