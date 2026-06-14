# frozen_string_literal: true

module Maglev
  module Uikit
    module AppLayout
      module Topbar
        class PageInfoComponentPreview < ViewComponent::Preview
          # Short title — fits easily in the bar.
          def default
            render_with_template(
              template: 'maglev/uikit/app_layout/topbar/page_info_component_preview/default',
              locals: { page: build_page(title: 'Welcome!', path: 'index') }
            )
          end

          # Very long title — must be truncated with an ellipsis, not overflow into the "…" button.
          def with_long_title
            render_with_template(
              template: 'maglev/uikit/app_layout/topbar/page_info_component_preview/default',
              locals: { page: build_page(
                # rubocop:disable Layout/LineLength
                title: 'This is an extremely long page title that should be truncated before it reaches the actions button',
                # rubocop:enable Layout/LineLength
                path: 'about'
              ) }
            )
          end

          # Long path — must also be truncated.
          def with_long_path
            render_with_template(
              template: 'maglev/uikit/app_layout/topbar/page_info_component_preview/default',
              locals: { page: build_page(
                title: 'Home',
                path: 'this/is/a/very/deeply/nested/page/path/that/would/normally/overflow'
              ) }
            )
          end

          # Both title and path are long.
          def with_long_title_and_path
            render_with_template(
              template: 'maglev/uikit/app_layout/topbar/page_info_component_preview/default',
              locals: {
                page: build_page(
                  title: 'Another very long title that should still be truncated properly with an ellipsis',
                  path: 'this/is/a/very/deeply/nested/page/path/that/would/normally/overflow'
                )
              }
            )
          end

          private

          def build_page(title:, path:)
            Maglev::Page.new(id: 1, title: title, path: path)
          end
        end
      end
    end
  end
end
