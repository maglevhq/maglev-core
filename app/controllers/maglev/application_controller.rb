# frozen_string_literal: true

module Maglev
  class ApplicationController < ActionController::Base
    include Maglev::ServicesConcern
    include Maglev::ResourceIdConcern

    protect_from_forgery with: :exception

    helper_method :services, :use_engine_vite?

    private

    def use_engine_vite?
      true
    end
  end
end
