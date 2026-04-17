# frozen_string_literal: true

module Maglev
  module Uikit
    module SectionToolbar
      class SectionToolbarComponentPreview < ViewComponent::Preview
        # All keys the toolbar uses must be set; nil URLs make link_to call url_for({}) and break under Lookbook at "/".
        TOOLBAR_PREVIEW_PATHS = {
          show: '#',
          edit: '#',
          delete: '#',
          add: '#',
          blocks: '#'
        }.freeze

        def default
          render_with_template(locals: { preview_paths: TOOLBAR_PREVIEW_PATHS })
        end

        def with_preview_ratio_scale
          render_with_template(locals: { preview_paths: TOOLBAR_PREVIEW_PATHS })
        end
      end
    end
  end
end
