# frozen_string_literal: true

module Maglev
  module Spacing
    MOBILE_PX = {
      xs: 8,
      sm: 16,
      md: 24,
      lg: 40,
      xl: 60
    }.freeze

    DESKTOP_PX = {
      xs: 12,
      sm: 24,
      md: 40,
      lg: 80,
      xl: 120
    }.freeze

    BREAKPOINT = '768px'
    DEFAULT_MOBILE_PX = 24
    DEFAULT_DESKTOP_PX = 40

    module_function

    def mobile_px_for(size_key)
      MOBILE_PX.fetch(normalize_key(size_key), DEFAULT_MOBILE_PX)
    end

    def desktop_px_for(size_key)
      DESKTOP_PX.fetch(normalize_key(size_key), DEFAULT_DESKTOP_PX)
    end

    def mobile_css_for(size_key)
      "#{mobile_px_for(size_key)}px"
    end

    def desktop_css_for(size_key)
      "#{desktop_px_for(size_key)}px"
    end

    def normalize_key(size_key)
      size_key.to_s.to_sym
    end
  end
end
