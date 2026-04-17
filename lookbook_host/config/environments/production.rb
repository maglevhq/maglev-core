# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.public_file_server.headers = { "cache-control": "public, max-age=#{1.year.to_i}" }
  config.active_storage.service = :local
  config.active_storage.variant_processor = :disabled
  config.assume_ssl = true
  config.force_ssl = true
  config.log_tags = [:request_id]
  config.logger = ActiveSupport::TaggedLogging.logger($stdout)
  config.log_level = ENV.fetch('RAILS_LOG_LEVEL', 'info')
  config.active_support.report_deprecations = false
  config.i18n.fallbacks = true

  config.asset_host = 'https://assets.uikit.maglev.dev'

  # Kamal health checks hit /up with Host = Docker hostname (e.g. …:3000), not the public proxy host.
  config.host_authorization = { exclude: ->(request) { request.path == '/up' } }

  config.hosts << 'uikit.maglev.dev'
  config.hosts << ENV['HOSTNAME'] if ENV['HOSTNAME'].present?
  # Internal checks sometimes send only the 12-hex hostname suffix (see HostAuthorization logs).
  config.hosts << /\A[a-f0-9]{12}(:\d+)?\z/i

  config.view_component.previews.controller = 'ComponentPreviewController'
  config.view_component.previews.default_layout = 'preview_component'
end
