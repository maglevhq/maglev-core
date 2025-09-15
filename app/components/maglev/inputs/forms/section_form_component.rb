# frozen_string_literal: true

module Maglev
  module Inputs
    module Forms
      class SectionFormComponent < Maglev::Inputs::Forms::DynamicFormComponent
        attr_reader :section

        def initialize(section:, path:)
          super(
            values: section.settings,
            definitions: section.definition.settings,
            path: path,
            i18n_scope: "maglev.themes.#{section.theme_id}.sections.#{section.type}"
          )
          @section = section
        end

        delegate :value_of, to: :values

        def input_scope
          'section'
        end
      end
    end
  end
end