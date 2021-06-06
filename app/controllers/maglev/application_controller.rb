# frozen_string_literal: true

module Maglev
  class ApplicationController < ::ApplicationController
    protect_from_forgery with: :exception

    helper_method :services

    private

    def services
      @services ||= ::Maglev.services(
        context: ServiceContext.new(
          preview_mode?: preview_mode?,
          controller: self
        )
      )
    end

    def model_scopes(name)
      services.get_model_scopes.call[name]
    end

    def preview_mode?
      true
    end
  end
end
