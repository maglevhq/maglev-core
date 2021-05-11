# frozen_string_literal: true

module Maglev
  class DashboardController < ApplicationController
    def index
      @themes = [::Maglev.theme]
    end
  end
end
