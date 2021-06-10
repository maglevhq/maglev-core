module Maglev
  class TemplatesRootPath
    include Injectable

    dependency :fetch_theme

    def call
      "./#{theme.sections_path}"
    end

    def theme
      fetch_theme.call
    end
  end
end
