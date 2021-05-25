# frozen_string_literal: true

require 'jbuilder'

module Maglev
  class Engine < ::Rails::Engine
    isolate_namespace Maglev

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: 'spec/factories'
    end

    initializer :themes do |app|
      theme_reloader = app.config.file_watcher.new([], { Maglev.theme_path.to_s => ['.yml'] }) do
        Maglev.reload_theme!
      end
      app.reloaders << theme_reloader

      config.to_prepare do
        # everytime the code of the app or the engine changes, we reload the themes
        Rails.logger.debug '[MAGLEV] reloading the theme'
        theme_reloader.execute
      end

      config.after_initialize do
        Maglev.reload_theme!
      end
    end    

    initializer :services do
      Maglev.configure do |config|
        config.services = {
          fetch_site: Maglev::FetchSite,
          fetch_theme: Maglev::FetchTheme,
          fetch_page: Maglev::FetchPage,
          get_base_url: Maglev::GetBaseUrl
        }
      end
    end
  end
end
