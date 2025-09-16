# frozen_string_literal: true

module Maglev
  module Uikit
    module Form
      class ImageFieldComponent < Maglev::Uikit::BaseComponent
        attr_reader :label, :name, :search_path, :alt_text

        def initialize(name:, search_path:, options:, alt_text: nil)
          @name = name
          @search_path = search_path
          @value = options[:value]
          @label = options[:label]
          @alt_text = alt_text
          @spread_fields = options[:spread_fields] || false
        end

        def alt_text?
          alt_text.present?
        end

        def dom_id
          name.to_s.parameterize.underscore
        end

        def spread_fields?
          @spread_fields
        end

        def value
          return @value unless spread_fields?

          @value.is_a?(Hash) ? @value.compact_blank : { url: @value }
        end

        def image_url
          spread_fields? ? value[:url] : value
        end

        def hidden_input_names
          return [] unless spread_fields?

          %w[id url filename width height byte_size].index_with do |key|
            "#{name}[#{key}]"
          end
        end

        delegate :blank?, to: :value
      end
    end
  end
end
