# frozen_string_literal: true

module Maglev
  class ApplicationController < ::ApplicationController
    include Maglev::ServicesConcern

    protect_from_forgery with: :exception

    helper_method :services, :use_engine_webpacker?, :maglev_config

    private

    def use_engine_webpacker?
      true
    end

    def maglev_config
      Maglev.config
    end
  end
end
