# frozen_string_literal: true

require 'maglev_core'
require 'maglev/engine'
require 'maglev/config'

module Maglev
  ROOT_PATH = Pathname.new(File.join(__dir__, '..'))
  class << self
    attr_accessor :theme

    def theme_path
      Rails.root.join('app/theme')
    end

    def reload_theme!
      self.theme = Maglev::Theme.load(theme_path)
    end

    def webpacker
      @webpacker ||= ::Webpacker::Instance.new(
        root_path: ROOT_PATH,
        config_path: ROOT_PATH.join('config/webpacker.yml')
      )
    end
  end
end
