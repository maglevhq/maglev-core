# frozen_string_literal: true

module Maglev
  module Uikit
    module Form
      class ColorFieldComponentPreview < ViewComponent::Preview
        # @!group Variants

        def default
          render(Maglev::Uikit::Form::ColorFieldComponent.new(
                   name: 'user[background_color]',
                   options: {
                     label: 'Color'
                   }
                 ))
        end

        def with_value
          render(Maglev::Uikit::Form::ColorFieldComponent.new(
                   name: 'user[background_color]',
                   options: {
                     label: 'Color',
                     value: '#e11d48'
                   }
                 ))
        end

        def with_presets
          render(Maglev::Uikit::Form::ColorFieldComponent.new(
                   name: 'user[background_color]',
                   options: {
                     label: 'Color',
                     value: '#ec4899',
                     presets: [
                       '#ff80b5', '#9089fc', '#ec4899', '#eab308', '#6366f1', '#10b981'
                     ]
                   }
                 ))
        end

        def with_error
          render(Maglev::Uikit::Form::ColorFieldComponent.new(
                   name: 'user[background_color]',
                   options: {
                     label: 'Color',
                     value: '#6366f1',
                     error: 'must be present'
                   }
                 ))
        end

        # @!endgroup
      end
    end
  end
end
