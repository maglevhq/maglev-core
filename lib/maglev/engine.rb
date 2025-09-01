# frozen_string_literal: true

require 'vite_ruby'
require 'turbo-rails'
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

    delegate :vite_ruby, to: :class

    def self.vite_ruby
      @vite_ruby ||= ::ViteRuby.new(root: root, mode: Rails.env)
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

    # Serves the engine's vite-ruby when requested
    initializer 'maglev.vite_rails.static' do |app|
      if Rails.application.config.public_file_server.enabled
        # this is the right setup when the main application is already
        # using Vite for the theme assets.
        app.middleware.insert_after ActionDispatch::Static,
                                    Rack::Static,
                                    urls: ["/#{vite_ruby.config.public_output_dir}"],
                                    root: root.join(vite_ruby.config.public_dir),
                                    header_rules: [
                                      # rubocop:disable Style/StringHashKeys
                                      [:all, { 'Access-Control-Allow-Origin' => '*' }]
                                      # rubocop:enable Style/StringHashKeys
                                    ]
      else
        # mostly when running the application in production behind NGINX or APACHE
        app.middleware.insert_before 0,
                                     Rack::Static,
                                     urls: ["/#{vite_ruby.config.public_output_dir}"],
                                     root: root.join(vite_ruby.config.public_dir),
                                     header_rules: [
                                       # rubocop:disable Style/StringHashKeys
                                       [:all, { 'Access-Control-Allow-Origin' => '*' }]
                                       # rubocop:enable Style/StringHashKeys
                                     ]
      end
    end

    initializer 'maglev.vite_rails_engine.proxy' do |app|
      if vite_ruby.run_proxy?
        app.middleware.insert_before 0,
                                     ViteRuby::DevServerProxy,
                                     ssl_verify_none: true,
                                     vite_ruby: vite_ruby
      end
    end

    initializer 'maglev.vite_rails_engine.logger' do
      config.after_initialize do
        vite_ruby.logger = Rails.logger
      end
    end
  end
end
