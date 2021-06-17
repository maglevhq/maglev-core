# frozen_string_literal: true

module Maglev
  class ThemeGenerator < Rails::Generators::Base
    source_root File.expand_path('templates/theme', __dir__)
    hook_for :maglev_theme

    def create_theme_files
      directory 'app'
    end
  end
end
