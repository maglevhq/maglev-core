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
    if maglev_preview_path.directory?
      config.autoload_paths << maglev_preview_path.to_s
      config.eager_load_paths << maglev_preview_path.to_s
    end

    config.active_record.migration_error = false
  end
end
