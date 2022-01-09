# frozen_string_literal: true

module Maglev
  module ServicesConcern
    private

    def services
      # NOTE: neither alias nor alias_method could work in the PRO engine
      maglev_services
    end

    def maglev_services
      @maglev_services ||= ::Maglev.services(
        context: build_maglev_service_context
      )
    end

    def build_maglev_service_context
      ::Maglev::ServiceContext.new(
        rendering_mode: maglev_rendering_mode,
        controller: self
      )
    end

    def maglev_rendering_mode
      :live
    end
  end
end
