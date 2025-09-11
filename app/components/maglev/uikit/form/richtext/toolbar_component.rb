# frozen_string_literal: true

module Maglev
  module Uikit
    module Form
      module Richtext
        class ToolbarComponent < ViewComponent::Base
          def initialize(line_break: false)
            @line_break = line_break
          end

          def line_break?
            @line_break
          end
        end
      end
    end
  end
end
