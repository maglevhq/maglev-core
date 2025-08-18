# frozen_string_literal: true

# Add support for `translates(*attributes)` macro, which
# uses JSONB to store translations of the specified attrs.
module Maglev
  module Translatable
    class UnavailableLocaleError < RuntimeError; end
    extend ActiveSupport::Concern

    def translations_for(attr)
      # With MySQL, there is no default value for JSON columns, so we need to check for nil
      public_send("#{attr}_translations").presence || {}
    end

    def translate_attr_in(attr, locale, source_locale)
      translations_for(attr)[locale.to_s] ||= translations_for(attr)[source_locale.to_s]
    end

    # rubocop:disable Metrics/BlockLength
    class_methods do
      def order_by_translated(attr, direction)
        order(translated_arel_attribute(attr, Maglev::I18n.current_locale) => direction)
      end

      def translated_arel_attribute(attr, locale)
        return Arel.sql("#{attr}_translations->>'#{locale}'") unless mysql?

        # MySQL and MariaDB JSON support 🤬🤬🤬
        # Note: doesn't work with Rails 7.0.x
        json_extract = Arel::Nodes::NamedFunction.new(
          'json_extract',
          [Arel::Nodes::SqlLiteral.new("#{attr}_translations"), Arel::Nodes.build_quoted("$.#{locale}")]
        )
        Arel::Nodes::NamedFunction.new('json_unquote', [json_extract])
      end

      def translates(*attributes, presence: false)
        attributes.each do |attr|
          # MariaDB doesn't support native JSON columns (longtext instead), we need to force it.
          attribute("#{attr}_translations", :json) if respond_to?(:attribute)
          setup_accessors(attr)
        end
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
          public_send("#{attr}_translations=",
                      translations_for(attr).merge(Maglev::I18n.current_locale.to_s => value))
        end

        define_method(attr) { translations_for(attr)[Maglev::I18n.current_locale.to_s] }
        define_method("default_#{attr}") { translations_for(attr)[Maglev::I18n.default_locale.to_s] }
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end
