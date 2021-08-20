# frozen_string_literal: true

# Add support for `translates(*attributes)` macro, which
# uses JSONB to store translations of the specified attrs.
module Translatable
  class UnavailableLocaleError < RuntimeError; end
  extend ActiveSupport::Concern
  mattr_accessor :available_locales, default: %i[en]

  def translations_for(attr)
    public_send("#{attr}_translations")
  end

  class << self
    def default_locale
      available_locales.first
    end

    def current_locale
      Current.locale || default_locale
    end

    def current_locale=(locale)
      raise UnavailableLocaleError unless available_locales.include?(locale)

      Current.locale = locale
    end

    def with_locale(locale, &block)
      Current.set(locale: locale, &block)
    end
  end

  class_methods do
    def order_by_translated(attr, direction)
      order(Arel.sql("#{attr}_translations->>'#{Translatable.current_locale}'") => direction)
    end

    def translates(*attributes, presence: false)
      attributes.each { |attr| setup_accessors(attr) }

      add_presence_validator(attributes) if presence
    end

    private

    def add_presence_validator(attributes)
      validate do
        attributes.each do |attribute|
          errors.add(attribute, :blank) if public_send(attribute).blank?
        end
      end
    end

    def setup_accessors(attr)
      define_method("#{attr}=") do |value|
        public_send("#{attr}_translations=", translations_for(attr).merge(Translatable.current_locale => value))
      end

      define_method(attr) { translations_for(attr)[Translatable.current_locale.to_s] }
    end
  end

  class Current < ActiveSupport::CurrentAttributes
    attribute :locale
  end
end
