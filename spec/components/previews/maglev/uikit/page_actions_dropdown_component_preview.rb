# frozen_string_literal: true

module Maglev
  module Uikit
    class PageActionsDropdownComponentPreview < ViewComponent::Preview
      def default
        render(Maglev::Uikit::PageActionsDropdownComponent.new(
                 paths: paths,
                 live_url: 'https://www.google.com'
               ))
      end

      def without_some_actions
        render(Maglev::Uikit::PageActionsDropdownComponent.new(
                 paths: paths,
                 live_url: 'https://www.google.com',
                 without_actions: [:delete]
               ))
      end

      def without_the_live_url
        render(Maglev::Uikit::PageActionsDropdownComponent.new(
                 paths: paths,
                 live_url: nil,
                 without_actions: [:delete]
               ))
      end

      private

      # Match keys used in page_actions_dropdown_component.html.erb (same as editor pages/_list).
      def paths
        {
          edit: "#",
          preview: "#",
          clone: "#",
          delete: "#"
        }
      end
    end
  end
end
