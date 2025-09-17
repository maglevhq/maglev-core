# frozen_string_literal: true

module Maglev
  module Editor
    module Settings
      module Divider
        class DividerComponent < Maglev::Editor::Settings::BaseComponent
          def with_hint?
            definition.options[:with_hint]
          end
        end
      end
    end
  end
end
