# frozen_string_literal: true

module Maglev
  class ApplicationController < ::ApplicationController
    protect_from_forgery with: :exception

    helper_method :services

    private

    def services
      @services ||= ::Maglev.services(controller: self)
    end

    def model_scopes(name)
      services.get_model_scopes.call[name]
    end
  end
end
