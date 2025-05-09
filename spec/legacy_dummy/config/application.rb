# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require 'maglev'

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    if Rails::VERSION::MAJOR > 6
      config.load_defaults 7.0
    else
      config.load_defaults 6.0
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.i18n.available_locales = %i[en fr]

    config.public_file_server.headers = {
      "cache-control": "max-age=#{1.year.to_i}, public"
    }.with_indifferent_access
  end
end
