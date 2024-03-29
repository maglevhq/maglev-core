# frozen_string_literal: true

module Maglev
  module ContentLocaleConcern
    extend ActiveSupport::Concern

    included do
      alias_method :maglev_content_locale, :content_locale

      helper_method :maglev_content_locale, :content_locale
    end

    private

    def set_content_locale
      locale = params[:locale] || request.headers['X-MAGLEV-LOCALE']
      Maglev::I18n.current_locale = locale if locale
    end

    def content_locale
      Maglev::I18n.current_locale
    end

    def default_content_locale
      maglev_site.default_locale.prefix
    end
  end
end
