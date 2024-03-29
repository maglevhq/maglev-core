# frozen_string_literal: true

module Maglev
  class ApplicationController < ::ApplicationController
    include Maglev::ServicesConcern

    protect_from_forgery with: :exception

    helper_method :services, :use_engine_vite?

    private

    def use_engine_vite?
      true
    end

    def resource_id
      # A standard UUID code contains 32 hex digits along with 4 "-"" symbols
      Maglev.uuid_as_primary_key? && params[:id] ? params[:id][0..35] : params[:id]
    end
  end
end
