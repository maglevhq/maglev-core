# frozen_string_literal: true

module Maglev
  # Extract the locale from the current HTTP request
  # and set the Translatable.current_locale accordingly
  class ExtractLocale
    include Injectable

    argument :params
    argument :locales

    def call
      locale, path = extract_locale

      Maglev::I18n.current_locale = locale

      params[:path] = path

      [path, locale]
    end

    protected

    def extract_locale
      path = params[:path] || 'index'
      segments = path.split('/')

      return [default_locale, path] unless locales.include?(segments[0]&.to_sym)

      [segments.shift, segments.empty? ? 'index' : segments.join('/')]
    end

    def default_locale
      locales.first
    end
  end
end
