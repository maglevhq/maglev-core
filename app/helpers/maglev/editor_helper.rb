# frozen_string_literal: true

module Maglev
  module EditorHelper
    def site_editor_path
      editor_path
    end

    def api_base_path
      "#{root_path}api"
    end
  end
end
