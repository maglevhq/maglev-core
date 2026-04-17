# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  config.enable_reloading = true
  config.eager_load = false
  config.consider_all_requests_local = true
  config.server_timing = true
  config.action_controller.perform_caching = false
  config.cache_store = :memory_store
  config.active_storage.service = :local
  config.action_controller.raise_on_missing_callback_actions = true

  config.view_component.previews.controller = 'ComponentPreviewController'
  config.view_component.previews.default_layout = 'preview_component'
end
