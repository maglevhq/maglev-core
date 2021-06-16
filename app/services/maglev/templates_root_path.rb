module Maglev
  class TemplatesRootPath
    include Injectable

    dependency :fetch_sections_path

    def call
      "./#{fetch_sections_path.call}"
    end
  end
end
