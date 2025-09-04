# frozen_string_literal: true

module Maglev
  module Inputs
    module Forms
      class SectionFormComponent < ViewComponent::Base
        attr_reader :section, :path

        def initialize(section:, path:)
          @section = section
          @path = path
        end

        def i18n_scope
          "maglev.themes.#{section.theme_id}.sections.#{section.type}"
        end

        def input_instance_for(setting)
          klass_or_proc = input_classes_map.fetch(setting.type.to_sym, Maglev::Inputs::InputBaseComponent)
          klass = klass_or_proc.is_a?(Proc) ? klass_or_proc.call(setting) : klass_or_proc

          klass.new(
            setting: setting, 
            value: section.settings.value_of(setting.id), 
            scope: 'section', 
            i18n_scope: i18n_scope
          )
        end

        private

        def input_classes_map
          {
            text: Proc.new { |setting| text_input_class(setting) },
            image: Maglev::Inputs::Image::ImageComponent,
            select: Maglev::Inputs::Select::SelectComponent
          }
        end

        def text_input_class(_setting)
          # TODO: we have different text inputs for text, textarea, rich text.
          Maglev::Inputs::Text::TextComponent
        end
      end
    end
  end
end
