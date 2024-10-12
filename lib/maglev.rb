# frozen_string_literal: true

require_relative 'maglev/version'
require_relative 'maglev/engine'
require_relative 'maglev/config'
require_relative 'maglev/plugins'
require_relative 'maglev/errors'
require_relative 'maglev/i18n'
require_relative 'maglev/preview_constraint'
require_relative 'maglev/reserved_paths'

require 'injectable'
require 'jbuilder'

module Maglev
  ROOT_PATH = Pathname.new(File.join(__dir__, '..'))

  ServiceContext = Struct.new(:rendering_mode, :controller, :site, keyword_init: true)

  class << self
    attr_accessor :local_themes

    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def config
      @config ||= config_klass.new.tap do |c|
        c.title = 'Maglev - EDITOR'
        c.favicon = nil
        c.logo = nil
        c.primary_color = '#040712'
        c.uploader = 'active_storage'
        c.site_publishable = false
        c.preview_host = nil
        c.asset_host = Rails.application.config.action_controller.asset_host
        c.ui_locale = nil
        c.back_action = nil
        c.services = {}
        c.default_site_locales = [{ label: 'English', prefix: 'en' }]
        c.is_authenticated = ->(_site) { !Rails.env.production? }
        c.admin_username = nil
        c.admin_password = nil
        c.static_pages = []
        c.reserved_paths = []
      end
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

    def configure
      config.tap do
        yield(config)
        config.reserved_paths = Maglev::ReservedPaths.new(config.reserved_paths)
      end
    end

    def uploader
      require_relative "maglev/#{config.uploader}"
      const_get("::Maglev::#{config.uploader.to_s.classify}")
    end

    def services(overrides = {})
      ::Maglev::AppContainer.new(config.services.merge(overrides)).call
    end

    def uuid_as_primary_key?
      return @uuid_as_primary_key unless @uuid_as_primary_key.nil?

      config = Rails.configuration.generators
      @uuid_as_primary_key = config.options[config.orm][:primary_key_type] == :uuid
    end

    def config_klass
      ::Maglev::Config
    end

    def plugins
      @plugins ||= Maglev::Plugins.new
    end

    def register_plugin(id:, root_path:, name: nil, version: nil)
      plugins.register(id:, name:, root_path:, version:)
    end

    def register_setting_type(id:, klass: nil)
      ::Maglev::SettingTypeRegistry.register(id:, klass:)
    end
  end
end
