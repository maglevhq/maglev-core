# frozen_string_literal: true

require_relative 'maglev/version'
require_relative 'maglev/engine'
require_relative 'maglev/config'
require_relative 'maglev/errors'
require_relative 'maglev/i18n'
require_relative 'maglev/preview_constraint'

require 'injectable'
require 'jbuilder'

module Maglev
  ROOT_PATH = Pathname.new(File.join(__dir__, '..'))

  app_dir = File.expand_path('../app', __dir__)
  autoload :APIController, "#{app_dir}/controllers/maglev/api_controller"
  autoload :JSONConcern, "#{app_dir}/controllers/concerns/maglev/json_concern"
  autoload :API, "#{app_dir}/controllers/maglev/api"

  ServiceContext = Struct.new(:rendering_mode, :controller, keyword_init: true)

  class << self
    attr_accessor :local_themes

    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def config
      @config ||= Config.new.tap do |c|
        c.title = 'Maglev - EDITOR'
        c.favicon = nil
        c.logo = nil
        c.primary_color = '#7E6EDB'
        c.uploader = 'active_storage'
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
      yield config
    end

    def uploader
      require_relative "maglev/#{config.uploader}"
      const_get("::Maglev::#{config.uploader.to_s.classify}")
    end

    def services(overrides = {})
      ::Maglev::AppContainer.new(config.services.merge(overrides)).call
    end

    def webpacker
      @webpacker ||= ::Webpacker::Instance.new(
        root_path: ROOT_PATH,
        config_path: ROOT_PATH.join('config/webpacker.yml')
      )
    end
  end
end
