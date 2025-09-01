# frozen_string_literal: true

module Maglev
  module Uikit
    module Form
      class SearchFormComponentPreview < ViewComponent::Preview
        # @!group Variants

        def default
          render(Maglev::Uikit::Form::SearchFormComponent.new(name: 'q', value: '', search_path: '#',
                                                              options: component_options))
        end

        def with_value
          render(Maglev::Uikit::Form::SearchFormComponent.new(name: 'q', value: 'test', search_path: '#',
                                                              options: component_options))
        end

        private

        def component_options
          {
            placeholder: 'Search for a page'
          }
        end

        # @!endgroup
      end
    end
  end
end
