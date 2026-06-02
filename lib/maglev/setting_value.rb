# frozen_string_literal: true

module Maglev
  module SettingValue
    module_function

    # Lit la valeur d'une checkbox Maglev (Maglev::Content::Checkbox).
    def checkbox_truthy?(setting, default: false)
      return default if setting.nil?

      setting.respond_to?(:true?) ? setting.true? : !!setting
    end

    # Lit la valeur d'un select Maglev avec fallback sur la valeur par défaut du YAML.
    def select_string(setting, default: nil)
      return default if setting.nil?

      value = setting.to_s.presence
      if value.blank? && setting.respond_to?(:setting) && setting.setting.respond_to?(:default)
        value = setting.setting.default.to_s.presence
      end

      value.presence || default
    end
  end
end
