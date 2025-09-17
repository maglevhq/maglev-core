# frozen_string_literal: true

module Maglev
  module Editor
    module Settings
      module Icon
        class IconComponent < Maglev::Editor::Settings::BaseComponent
          def search_path
            fetch_path(:icons_path, { source: input_source })
          end
        end
      end
    end
  end
end
