# frozen_string_literal: true

module Maglev
  module Editor
    module Settings
      module Image
        class ImageComponent < Maglev::Editor::Settings::BaseComponent
          def after_initialize
            @value = value&.with_indifferent_access
          end

          def alt_text_input_name
            "#{input_name}[alt_text]"
          end

          def search_path
            fetch_path(:assets_path, { source: input_source })
          end
        end
      end
    end
  end
end
