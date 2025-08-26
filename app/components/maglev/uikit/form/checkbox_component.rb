# frozen_string_literal: true

module Maglev
  module Uikit
    module Form
      class CheckboxComponent < ViewComponent::Base
        attr_reader :label, :name, :placeholder

        def initialize(label:, name:, checked: false, placeholder: nil)
          @label = label
          @name = name
          @checked = checked
          @placeholder = placeholder
        end

        def checked?
          @checked
        end

        def dom_id
          name.to_s.parameterize.underscore
        end
      end
    end
  end
end
