# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require 'maglev'

module LookbookHost
  class Application < Rails::Application
    config.load_defaults Rails::VERSION::STRING.to_f
    config.eager_load_paths << Rails.root.join('lib')

    # ViewComponent/Lookbook previews live under the engine repo (spec/components/previews).
    # They must be Zeitwerk-visible so production eager load resolves *ComponentPreview constants.
    maglev_preview_path = Rails.root.join('../spec/components/previews').expand_path
    lookbook_docs_path = Rails.root.join('docs/lookbook').expand_path
    uikit_path = Maglev::Engine.root.join('app', 'components', 'maglev', 'uikit').expand_path
    maglev_logo_path = Maglev::Engine.root.join('app', 'assets', 'images', 'maglev', 'logo.svg').expand_path

    raise "Lookbook preview path does not exist: #{maglev_preview_path}" unless maglev_preview_path.directory?
    raise "Lookbook docs path does not exist: #{lookbook_docs_path}" unless lookbook_docs_path.directory?

    config.autoload_paths << maglev_preview_path.to_s
    config.eager_load_paths << maglev_preview_path.to_s

    # Set during application configuration so Lookbook::Engine picks up page_paths when it loads pages.
    config.view_component.previews.paths = [maglev_preview_path.to_s]

    config.lookbook.project_name = 'Maglev UIKit'
    config.lookbook.project_logo = File.read(maglev_logo_path) if maglev_logo_path.file?
    config.lookbook.listen_paths << uikit_path.to_s
    config.lookbook.listen_paths << lookbook_docs_path.to_s
    config.lookbook.listen_extensions = %w[js css]
    config.lookbook.preview_paths = [maglev_preview_path.to_s]
    config.lookbook.page_paths = [lookbook_docs_path.to_s]
    # Lookbook only treats `*.md.*` (e.g. page.md.erb) as Markdown by default; plain `*.md` does not.
    config.lookbook.page_options = { markdown: true }
    config.lookbook.ui_theme_overrides = {
      header_bg: '#111827'
    }
    config.lookbook.preview_display_options = {
      theme: [%w[Default default]],
      lang: [
        %w[English en],
        %w[French fr]
      ]
    }

    config.active_record.migration_error = false
  end
end
