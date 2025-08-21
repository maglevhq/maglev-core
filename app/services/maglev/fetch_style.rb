# frozen_string_literal: true

module Maglev
  # Fetch the style of a site. Use default values from the theme if needed.
  class FetchStyle
    include Injectable

    dependency :fetch_site
    dependency :fetch_theme

    def call
      Maglev::Site::StyleValue::AssociationProxy.new(
        build_style_value_list
      )
    end

    protected

    def site
      @site ||= fetch_site.call
    end

    def theme
      @theme ||= fetch_theme.call
    end

    def build_style_value_list
      theme.style_settings.map do |definition|
        build_style_value(definition)
      end
    end

    def build_style_value(definition)
      Maglev::Site::StyleValue.new(
        definition.id,
        definition.type,
        custom_value(definition)
      )
    end

    def custom_value(definition)
      value = (site.style || []).find do |local_value|
        local_value['id'] == definition.id && local_value['type'] == definition.type
      end
      value ? value['value'] : definition.default
    end
  end
end
