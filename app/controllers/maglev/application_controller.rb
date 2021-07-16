# frozen_string_literal: true

module Maglev
  class ApplicationController < ::ApplicationController
    protect_from_forgery with: :exception

    helper_method :services, :use_engine_webpacker?, :maglev_config

    private

    def services
      @services ||= ::Maglev.services(
        context: build_service_context
      )
    end

    def build_service_context
      ServiceContext.new(
        rendering_mode: rendering_mode,
        controller: self
      )
    end

    def rendering_mode
      :live
    end

    def use_engine_webpacker?
      true
    end

    def maglev_config
      Maglev.config
    end
  end
end
