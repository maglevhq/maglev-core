# frozen_string_literal: true

module Maglev
  class ApplicationController < ::ApplicationController
    include Maglev::ServicesConcern

    protect_from_forgery with: :exception

    helper_method :services, :use_engine_webpacker?

    private

    def use_engine_webpacker?
      true
    end    
  end
end
