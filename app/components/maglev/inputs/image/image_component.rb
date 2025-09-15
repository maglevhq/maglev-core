# frozen_string_literal: true

module Maglev
  module Inputs
    module Image
      class ImageComponent < Maglev::Inputs::InputBaseComponent
        def initialize(definition:, value:, scope:, i18n_scope:)
          super
          @value = value&.with_indifferent_access
        end

        # required by the ImageLibrary modal when selecting an image
        def image_source
          input_name.parameterize.underscore
        end

        def alt_text_input_name
          "#{input_name}[alt_text]"
        end
      end
    end
  end
end
