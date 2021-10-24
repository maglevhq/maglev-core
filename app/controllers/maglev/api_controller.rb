# frozen_string_literal: true

module Maglev
  class APIController < ::Maglev::ApplicationController
    include Maglev::JSONConcern
    include Maglev::UiLocaleConcern
    include Maglev::ContentLocaleConcern
 
    before_action :fetch_maglev_site
    before_action :set_content_locale

    rescue_from ActiveRecord::RecordInvalid, with: :record_errors
    rescue_from ActionController::ParameterMissing, with: :exception_message
    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    helper_method :maglev_site

    private

    def fetch_maglev_site
      maglev_site # simply force the fetching of the current site
    end

    def maglev_site
      @maglev_site ||= services.fetch_site.call
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
