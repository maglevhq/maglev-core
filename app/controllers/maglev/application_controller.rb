# frozen_string_literal: true

module Maglev
  class ApplicationController < ::ApplicationController
    protect_from_forgery with: :exception
  end
end
