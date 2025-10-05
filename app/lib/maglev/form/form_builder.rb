# frozen_string_literal: true

module Maglev
  module Form
    class FormBuilder < ActionView::Helpers::FormBuilder
      include Maglev::Form::Inputs::TextField
      include Maglev::Form::Inputs::ImageField
      include Maglev::Form::Inputs::CheckBox
      include Maglev::Form::Inputs::Textarea
      include Maglev::Form::Inputs::Combobox
      include Maglev::Form::Inputs::Select

      private

      def field_attributes(method)
        {
          id: field_id(method),
          name: field_name(method),
          content: label_translation(method)
        }
      end

      def error_messages(method)
        return unless object.errors.any? && object.errors.messages_for(method).present?

        object.errors.messages_for(method).join(', ')
      end

      def label_translation(method)
        content = nil
        ActionView::Helpers::Tags::Label.new(@object_name, method, @template).render do |builder|
          content = builder.translation
        end
        content
      end
    end
  end
end
