# frozen_string_literal: true

module Maglev
  module ErrorsConcern
    extend ActiveSupport::Concern

    included do
      rescue_from ::Maglev::Errors::SiteNotFound, with: :handle_site_not_found if Rails.env.development?
    end

    private

    def handle_site_not_found
      render 'maglev/errors/site_not_found', layout: nil, status: :not_found
    end
  end
end
