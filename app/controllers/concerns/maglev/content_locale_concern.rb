# frozen_string_literal: true

module Maglev
  module ContentLocaleConcern
    extend ActiveSupport::Concern

    included do
      helper_method :content_locale
    end

    private

    def set_content_locale
      locale = params[:locale] || request.headers['X-MAGLEV-LOCALE']
      Translatable.current_locale = locale if locale
    end

    def content_locale
      Translatable.current_locale
    end

    def default_content_locale
      maglev_site.default_locale.prefix
    end
  end
end
