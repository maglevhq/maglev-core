# frozen_string_literal: true

module Maglev
  module Uikit
    module List
      class ListItemComponentPreview < ViewComponent::Preview
        # @!group Variants
        def default
          render_with_template
        end

        def with_pre_title
          render_with_template
        end

        def with_image
          render_with_template
        end

        def with_delete_button
          render_with_template
        end

        def with_handle
          render_with_template
        end

        # @!endgroup
      end
    end
  end
end
