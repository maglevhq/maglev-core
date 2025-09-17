# frozen_string_literal: true

module Maglev
  module Editor
    module SettingRegistry
      def self.instance
        @instance ||= Instance.new(components: default_components)
      end

      # rubocop:disable Metrics/MethodLength
      def self.default_components
        {
          text: proc { |definition| instance.text_field_klass(definition) },
          image: Maglev::Editor::Settings::Image::ImageComponent,
          select: Maglev::Editor::Settings::Select::SelectComponent,
          link: Maglev::Editor::Settings::Link::LinkComponent,
          color: Maglev::Editor::Settings::Color::ColorComponent,
          checkbox: Maglev::Editor::Settings::Checkbox::CheckboxComponent,
          collection_item: Maglev::Editor::Settings::CollectionItem::CollectionItemComponent,
          icon: Maglev::Editor::Settings::Icon::IconComponent,
          divider: Maglev::Editor::Settings::Divider::DividerComponent,
          hint: Maglev::Editor::Settings::Hint::HintComponent
        }
      end
      # rubocop:enable Metrics/MethodLength

      class Instance
        attr_reader :components

        def initialize(components: {})
          @components = components
        end

        def register(type, component_klass_or_proc)
          components[type.to_sym] = component_klass_or_proc
        end

        def fetch(definition)
          klass_or_proc = components.fetch(definition.type.to_sym, nil)
          klass = klass_or_proc.is_a?(Proc) ? klass_or_proc.call(definition) : klass_or_proc

          return Maglev::Editor::Settings::BaseComponent if klass.nil?

          klass
        end

        def text_field_klass(definition)
          if definition.options[:html]
            Maglev::Editor::Settings::Text::RichtextComponent
          elsif definition.options[:nb_rows].to_i > 1
            Maglev::Editor::Settings::Text::TextareaComponent
          else
            Maglev::Editor::Settings::Text::TextComponent
          end
        end
      end
    end
  end
end
