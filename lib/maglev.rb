# frozen_string_literal: true

require 'maglev_core'
require 'maglev/engine'
require 'maglev/config'

module Maglev
  class << self
    attr_accessor :theme

    def theme_path
      Rails.root.join('app/theme')
    end

    def reload_theme!
      self.theme = Maglev::Theme.load(theme_path)
    end
  end
end
