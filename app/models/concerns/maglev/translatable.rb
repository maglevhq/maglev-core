# frozen_string_literal: true

# Add support for `translates(*attributes)` macro, which
# uses JSONB to store translations of the specified attrs.
module Maglev
  module Translatable
    class UnavailableLocaleError < RuntimeError; end
    extend ActiveSupport::Concern

    def translations_for(attr)
      public_send("#{attr}_translations")
    end

    def translate_attr_in(attr, locale, source_locale)
      translations_for(attr)[locale.to_s] ||= translations_for(attr)[source_locale.to_s]
    end

    class_methods do
      def order_by_translated(attr, direction)
        order(Arel.sql("#{attr}_translations->>'#{Maglev::I18n.current_locale}'") => direction)
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
          public_send("#{attr}_translations=", translations_for(attr).merge(Maglev::I18n.current_locale => value))
        end

        define_method(attr) { translations_for(attr)[Maglev::I18n.current_locale.to_s] }
        define_method("default_#{attr}") { translations_for(attr)[Maglev::I18n.default_locale.to_s] }
      end
    end
  end
end
