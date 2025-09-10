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

        def input_scope
          'section'
        end

        def value_of(setting_id)
          section.settings.value_of(setting_id)
        end

        def input_instance_for(setting)
          klass_or_proc = input_klasses_map.fetch(setting.type.to_sym, nil)
          klass = klass_or_proc.is_a?(Proc) ? klass_or_proc.call(setting) : klass_or_proc

          klass = Maglev::Inputs::InputBaseComponent if klass.nil?
          
          klass.new(
            setting: setting,
            value: value_of(setting.id),
            scope: input_scope,
            i18n_scope: i18n_scope
          )
        end

        private

        def input_klasses_map
          {
            text: proc { |setting| text_input_klass(setting) },
            image: Maglev::Inputs::Image::ImageComponent,
            select: Maglev::Inputs::Select::SelectComponent,
            link: Maglev::Inputs::Link::LinkComponent
          }
        end

        def text_input_klass(setting)
          if setting.options[:html]
            Maglev::Inputs::Text::RichtextComponent
          elsif setting.options[:nb_rows].to_i > 1
            Maglev::Inputs::Text::TextareaComponent
          else
            Maglev::Inputs::Text::TextComponent
          end
        end
      end
    end
  end
end
