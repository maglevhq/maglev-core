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

  def content_image(value)
    value&.fetch('url', nil)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
