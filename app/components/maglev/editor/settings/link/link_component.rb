# frozen_string_literal: true

module Maglev
  module Editor
    module Settings
      module Link
        class LinkComponent < Maglev::Editor::Settings::BaseComponent
          def edit_link_path
            fetch_path(:edit_link_path, { link: value, source: input_name })
          end
        end
      end
    end
  end
end