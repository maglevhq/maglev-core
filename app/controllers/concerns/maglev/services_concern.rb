# frozen_string_literal: true

module Maglev
  module ServicesConcern
    extend ActiveSupport::Concern

    included do
      helper_method :maglev_config, :maglev_services
    end

    private

    def services
      # NOTE: neither alias nor alias_method could work in the PRO engine
      maglev_services
    end

    def maglev_services
      @maglev_services ||= ::Maglev.services(maglev_services_overrides)
    end

    def maglev_services_overrides
      {
        context: build_maglev_service_context
      }
    end

    def build_maglev_service_context
      ::Maglev::ServiceContext.new(
        rendering_mode: maglev_rendering_mode,
        controller: self,
        site: nil
      )
    end

    def maglev_rendering_mode
      :live
    end

    def maglev_config
      Maglev.config
    end
  end
end
