# frozen_string_literal: true

module Maglev
  # Fetch the style of a site. Use default values from the theme if needed.
  class FetchStyle
    include Injectable

    argument :site
    argument :theme

    def call
      Maglev::Site::StyleValue::Store.new(
        build_style_value_list
      )
    end

    protected

    def build_style_value_list
      theme.style_settings.map do |setting|
        build_style_value(setting)
      end
    end

    def build_style_value(setting)
      Maglev::Site::StyleValue.new(
        setting.id,
        setting.type,
        custom_value(setting)
      )
    end

    def custom_value(setting)
      value = site.style.find { |local_value| local_value['id'] == setting.id }
      value && value['type'] == setting.type ? value['value'] : setting.default
    end
  end
end
