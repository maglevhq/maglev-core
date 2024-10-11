# frozen_string_literal: true

module Maglev
  class PluginGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('templates/plugin', __dir__)

    def create_plugin_package
      directory 'packages'
    end

    def add_plugin_javascript_setup_file
      directory 'app'
    end

    def add_plugin_gem
      gem table_name, path: "./packages/#{table_name}"
    end

    def instructions
      $stdout.puts <<~INFO

        Done! 🎉

        Next steps:
        - bundle install
        - bundle exec rails maglev:vite:install_dependencies

        ⚠️ Don't forget to restart your application server

        Alright, now, you can start coding your plugin at `packages/#{name}`.

        👉 Please visit our documentation site to know more about Maglev plugins.
      INFO
    end

    private

    def pluralize_table_names?
      false
    end
  end
end
