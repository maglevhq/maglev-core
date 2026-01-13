# frozen_string_literal: true

module Maglev
  module Editor
    module Settings
      module Link
        class LinkComponent < Maglev::Editor::Settings::BaseComponent
          def edit_link_path
            fetch_path(:edit_link_path, { value: value || default_value, input_name: input_name })
          end

          def after_initialize
            @value = value&.with_indifferent_access
          end

          private

          def default_value
            { link_type: 'url' }
          end
        end
      end
    end
  end
end
