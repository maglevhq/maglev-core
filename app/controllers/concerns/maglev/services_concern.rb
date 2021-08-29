# frozen_string_literal: true

module Maglev
  module ServicesConcern
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
  end
end
