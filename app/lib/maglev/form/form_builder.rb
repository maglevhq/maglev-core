# frozen_string_literal: true

module Maglev
  module Form
    class FormBuilder < ActionView::Helpers::FormBuilder
      include Maglev::Form::Inputs::TextField
      include Maglev::Form::Inputs::ImageField
      include Maglev::Form::Inputs::CheckBox
      include Maglev::Form::Inputs::Textarea

      private

      def field_attributes(method)
        ActionView::Helpers::Tags::Label.new(@object_name, method, @template, nil,
                                             objectify_options({})).complete_attributes
      end

      def error_messages(method)
        return unless object.errors.any? && object.errors.messages_for(method).present?

        object.errors.messages_for(method).join(', ')
      end

      # rubocop:disable Style/ClassAndModuleChildren, Metrics/MethodLength, Metrics/AbcSize
      class ActionView::Helpers::Tags::Label
        def complete_attributes
          options = @options.stringify_keys
          tag_value = options.delete('value')
          name_and_id = options.dup

          if name_and_id['for']
            name_and_id['id'] = name_and_id['for']
          else
            name_and_id.delete('id')
          end

          add_default_name_and_id_for_value(tag_value, name_and_id)
          options.delete('index')
          options.delete('namespace')
          options['for'] = name_and_id['id'] unless options.key?('for')

          builder = LabelBuilder.new(@template_object, @object_name, @method_name, @object, tag_value)

          content = render_component(builder)

          { content: content }.merge(name_and_id.symbolize_keys)
        end
      end
      # rubocop:enable Style/ClassAndModuleChildren, Metrics/MethodLength, Metrics/AbcSize
    end
  end
end
