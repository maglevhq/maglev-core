# frozen_string_literal: true

module Maglev
  module Uikit
    module Form
      module Combobox
        class OptionComponent < ViewComponent::Base
          attr_reader :id, :label

          def initialize(id:, label:)
            @id = id
            @label = label
          end

          def to_args
            { id: id, label: label }
          end
        end
      end
    end
  end
end
