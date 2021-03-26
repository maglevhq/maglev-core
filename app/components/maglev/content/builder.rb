# frozen_string_literal: true

module Maglev
  module Content
    module Builder
      TYPES = {
        text: Maglev::Content::Text,
        image_picker: Maglev::Content::ImagePicker,
        checkbox: Maglev::Content::Checkbox
      }.freeze

      def build(scope, content, setting)
        TYPES[setting.type.to_sym].new(scope, content, setting)
      end

      module_function :build
    end
  end
end
