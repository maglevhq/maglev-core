# frozen_string_literal: true

module Maglev
  module Inputs
    module Forms
      class DynamicFormComponent < ViewComponent::Base
        attr_reader :values, :definitions, :path, :i18n_scope

        # values is the content built from the definitions (section, section_block or style)
        def initialize(values:, definitions:, path:, i18n_scope:)
          @values = values
          @definitions = definitions
          @i18n_scope = i18n_scope
          @path = path
        end

        def value_of(setting_id)
          raise Maglev::Errors::NotImplemented
        end

        def input_scope
          raise Maglev::Errors::NotImplemented
        end


        def input_instance_for(definition)
          klass_or_proc = input_klasses_map.fetch(definition.type.to_sym, nil)
          klass = klass_or_proc.is_a?(Proc) ? klass_or_proc.call(definition) : klass_or_proc

          klass = Maglev::Inputs::InputBaseComponent if klass.nil?

          klass.new(
            definition: definition,
            value: value_of(definition.id),
            scope: input_scope,
            i18n_scope: i18n_scope
          )
        end

        private

        def input_klasses_map
          {
            text: proc { |definition| text_input_klass(definition) },
            image: Maglev::Inputs::Image::ImageComponent,
            select: Maglev::Inputs::Select::SelectComponent,
            link: Maglev::Inputs::Link::LinkComponent,
            color: Maglev::Inputs::Color::ColorComponent
          }
        end

        def text_input_klass(definition)
          if definition.options[:html]
            Maglev::Inputs::Text::RichtextComponent
          elsif definition.options[:nb_rows].to_i > 1
            Maglev::Inputs::Text::TextareaComponent
          else
            Maglev::Inputs::Text::TextComponent
          end
        end
      end
    end
  end
end
