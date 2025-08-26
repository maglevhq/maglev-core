# frozen_string_literal: true

module Maglev
  module Uikit
    module List
      class ListComponentPreview < ViewComponent::Preview
        def default
          render_with_template
        end

        def sortable
          render_with_template
        end

        def sortable_with_insert_buttons
          render_with_template
        end
      end
    end
  end
end
