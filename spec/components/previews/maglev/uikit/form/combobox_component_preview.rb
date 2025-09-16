# frozen_string_literal: true

module Maglev
  module Uikit
    module Form
      class ComboboxComponentPreview < ViewComponent::Preview
        # @!group Variants
        def default
          render Maglev::Uikit::Form::ComboboxComponent.new(
            label: 'Page',
            name: 'page_id',
            search_path: search_path
          )
        end

        def with_placeholder
          render(Maglev::Uikit::Form::ComboboxComponent.new(
                   label: 'Page',
                   name: 'page2_id',
                   search_path: search_path,
                   options: { placeholder: 'Placeholder' }
                 ))
        end

        def with_value
          render(Maglev::Uikit::Form::ComboboxComponent.new(
                   label: 'Page',
                   name: 'page3_id',
                   search_path: search_path,
                   options: { value: '1', selected_label: 'Home page', clearable: true }
                 ))
        end

        def with_error
          render(Maglev::Uikit::Form::ComboboxComponent.new(
                   label: 'Page',
                   name: 'page4_id',
                   search_path: search_path,
                   options: { error: 'must be present' }
                 ))
        end

        # @!endgroup

        private

        def search_path
          '/maglev/editor/combobox/pages'
        end
      end
    end
  end
end
