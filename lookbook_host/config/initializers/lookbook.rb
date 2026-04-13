# frozen_string_literal: true

preview_path = Rails.root.join('../spec/components/previews').expand_path
uikit_path = Maglev::Engine.root.join('app', 'components', 'maglev', 'uikit').expand_path

raise "Lookbook preview path does not exist: #{preview_path}" unless preview_path.directory?

Rails.application.configure do
  config.view_component.previews.paths = [preview_path.to_s]

  config.lookbook.project_name = 'Maglev UIKit'
  config.lookbook.listen_paths << uikit_path.to_s
  config.lookbook.listen_extensions = %w[js css]
  config.lookbook.preview_paths = [preview_path.to_s]
  config.lookbook.preview_display_options = {
    theme: [%w[Default default]],
    lang: [
      %w[English en],
      %w[French fr]
    ]
  }
end
