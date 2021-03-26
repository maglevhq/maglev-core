# frozen_string_literal: true

module Maglev
  class ThemeGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('templates/theme', __dir__)

    def create_theme_files
      directory 'app'
    end
  end
end
