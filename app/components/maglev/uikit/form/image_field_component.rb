# frozen_string_literal: true

module Maglev
  module Uikit
    module Form
      class ImageFieldComponent < Maglev::Uikit::BaseComponent
        attr_reader :label, :name, :value, :search_path, :alt_text

        def initialize(label:, name:, value:, search_path:, alt_text: nil)
          @label = label
          @name = name
          @value = value
          @search_path = search_path
          @alt_text = alt_text
        end

        def alt_text?
          alt_text.present?
        end

        def dom_id
          name.to_s.parameterize.underscore
        end

        delegate :blank?, to: :value
      end
    end
  end
end
