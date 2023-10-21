# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::SettingTypes::Image < Maglev::SettingTypes::Base
  def cast_value(value)
    if value.is_a?(String)
      { url: value }
    else
      value || {}
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
