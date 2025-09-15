# frozen_string_literal: true

module Maglev
  module Inputs
    module Forms
      class StyleFormComponent < Maglev::Inputs::Forms::DynamicFormComponent
        def initialize(values:, theme:, path:)
          super(
            values: values,
            definitions: theme.style_settings,
            path: path,
            i18n_scope: "maglev.themes.#{theme.id}.style"
          )
        end

        delegate :value_of, to: :values

        def input_scope
          'style'
        end
      end
    end
  end
end
