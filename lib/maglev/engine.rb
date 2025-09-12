# frozen_string_literal: true

require 'turbo-rails'
require 'importmap-rails'
require 'maglev/migration'

module Maglev
  class Engine < ::Rails::Engine
    isolate_namespace Maglev

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: 'spec/factories'
    end

    initializer 'maglev.theme_reloader' do |app|
      require_relative './theme_filesystem_loader'
      theme_path = Rails.root.join('app/theme')
      theme_reloader = app.config.file_watcher.new([], { theme_path.to_s => ['.yml', 'yml'] }) do
        theme_loader = Maglev::ThemeFilesystemLoader.new(
          Maglev.services(context: nil).fetch_section_screenshot_path
        )
        Maglev.local_themes = [theme_loader.call(theme_path)]
      end

      app.reloaders << theme_reloader

      config.to_prepare do
        # everytime the code of the app or the engine changes, we reload the themes
        theme_reloader.execute
      end

      config.after_initialize do
        theme_reloader.execute
      end
    end

    initializer 'maglev.i18n' do |_app|
      Rails.application.config.i18n.load_path += Dir["#{config.root}/config/locales/**/*.yml"]
    end

    def self.importmaps
      @importmaps ||= {
        editor: ::Importmap::Map.new,
        client: ::Importmap::Map.new
      }
    end

    initializer 'maglev.importmap' do |app|
      Engine.importmaps[:editor].draw(Engine.root.join('config/editor_importmap.rb'))
      Engine.importmaps[:client].draw(Engine.root.join('config/client_importmap.rb'))

      app.config.assets.paths << Engine.root.join('app/components')
      app.config.assets.paths << Engine.root.join('app/assets/javascripts')
      app.config.assets.paths << Engine.root.join('vendor/javascript')
      app.config.assets.precompile += %w[maglev_manifest]

      if (Rails.env.development? || Rails.env.test?) && !app.config.cache_classes
        # Editor
        Engine.importmaps[:editor].cache_sweeper(watches: [
                                                   Engine.root.join('app/assets/javascripts'),
                                                   Engine.root.join('app/components')
                                                 ])

        # Client
        Engine.importmaps[:client].cache_sweeper(watches: [
                                                   Engine.root.join('app/assets/javascripts/maglev/client')
                                                 ])

        ActiveSupport.on_load(:action_controller_base) do
          before_action { Engine.importmaps[:editor].cache_sweeper.execute_if_updated }
          before_action { Engine.importmaps[:client].cache_sweeper.execute_if_updated }
        end
      end
    end
  end
end
