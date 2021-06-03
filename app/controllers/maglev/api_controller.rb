# frozen_string_literal: true

module Maglev
  class APIController < ::Maglev::ApplicationController
    include Maglev::JSONConcern

    rescue_from ActiveRecord::RecordInvalid, with: :record_errors
    rescue_from ActionController::ParameterMissing, with: :exception_message
    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    helper_method :current_site

    private

    def current_site
      @current_site ||= services.fetch_site.call
    end

    def record_errors(exception)
      render(json: { errors: exception.record.errors }, status: :bad_request)
    end

    def exception_message(exception)
      render(json: { errors: [exception.message] }, status: :bad_request)
    end

    def not_found
      head :not_found
    end
  end
end

Maglev::ApiController = Maglev::APIController
