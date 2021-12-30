# frozen_string_literal: true

# For example, the editor UI can be in English while the displayed Maglev content is in French.
# That's why we need another kind of I18n.locale only dedicated to Maglev content.
# Our Maglev::Translatable concern relies on this specific locale.
module Maglev
  module I18n
    class UnavailableLocaleError < RuntimeError; end

    class << self
      def available_locales
        Current.available_locales || %i[en]
      end

      def available_locales=(locales)
        Current.available_locales = locales.map(&:to_sym)
      end

      def default_locale
        available_locales.first
      end

      def current_locale
        Current.locale || default_locale
      end

      def current_locale=(locale)
        locale = locale.to_sym

        raise UnavailableLocaleError unless available_locales.include?(locale)

        Current.locale = locale
      end

      def with_locale(locale, &block)
        Current.set(locale: locale, &block)
      end
    end

    class Current < ActiveSupport::CurrentAttributes
      attribute :locale
      attribute :available_locales
    end
    private_constant :Current
  end
end
