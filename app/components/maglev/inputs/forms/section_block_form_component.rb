# frozen_string_literal: true

module Maglev
  module Inputs
    module Forms
      class SectionBlockFormComponent < Maglev::Inputs::Forms::SectionFormComponent
        attr_reader :section_block

        def initialize(section:, section_block:, advanced: false, path:)
          super(section: section, advanced: advanced, path: path)
          @section_block = section_block
        end

        def i18n_scope
          "maglev.themes.#{section.theme_id}.sections.#{section.type}.blocks.types.#{section_block.type}"
        end

        def input_scope
          'section_block'
        end

        def settings
          section_block.definition.settings.select { |definition| definition.advanced? == advanced }
        end

        def value_of(setting_id)
          section_block.settings.value_of(setting_id)
        end
      end
    end
  end
end
