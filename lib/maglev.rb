# frozen_string_literal: true

require 'maglev/engine'
require 'maglev/config'

module Maglev
  ROOT_PATH = Pathname.new(File.join(__dir__, '..'))

  class << self
    def webpacker
      @webpacker ||= ::Webpacker::Instance.new(
        root_path: ROOT_PATH,
        config_path: ROOT_PATH.join('config/webpacker.yml')
      )
    end

    def config
      @config ||= Config.new.tap do |c|
        c.favicon = 'favicon.ico'
        c.logo = 'logo.png'
        c.primary_color = '#7362D0'
      end
    end

    def configure
      yield config
    end

    def uploader
      require "maglev/#{config.uploader}"
      const_get("::Maglev::#{config.uploader.to_s.classify}")
    end
  end
end
