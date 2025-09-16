# frozen_string_literal: true

module Maglev
  module Inputs
    module Divider
      class DividerComponent < Maglev::Inputs::InputBaseComponent
        def with_hint?
          definition.options[:with_hint]
        end
      end
    end
  end
end
