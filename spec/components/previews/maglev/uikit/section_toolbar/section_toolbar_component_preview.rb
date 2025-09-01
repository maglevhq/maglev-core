# frozen_string_literal: true

module Maglev
  module Uikit
    module SectionToolbar
      class SectionToolbarComponentPreview < ViewComponent::Preview
        def default
          render_with_template
        end

        def with_preview_ratio_scale
          render_with_template
        end
      end
    end
  end
end
