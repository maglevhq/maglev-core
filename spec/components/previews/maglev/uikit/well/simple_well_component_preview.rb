# frozen_string_literal: true

module Maglev
  module Uikit
    module Well
      class SimpleWellComponentPreview < ViewComponent::Preview
        def default
          render_with_template
        end

        def with_action
          render_with_template
        end
      end
    end
  end
end
