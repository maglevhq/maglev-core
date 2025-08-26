# frozen_string_literal: true

module Maglev
  module Uikit
    module Form
      class TextareaComponent < ViewComponent::Base
        attr_reader :label, :name, :value, :rows, :max_length

        def initialize(label:, name:, value:, rows: 2, max_length: nil)
          @label = label
          @name = name
          @value = value
          @rows = rows
          @max_length = max_length
        end

        def dom_id
          name.to_s.parameterize.underscore
        end

        def num_characters
          value.to_s.length
        end

        def max_length?
          max_length.present?
        end
      end
    end
  end
end
