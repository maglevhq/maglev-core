# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::SettingTypes::Base
  def cast_value(value)
    value
  end

  def content_label(_value)
    nil
  end
end

# rubocop:enable Style/ClassAndModuleChildren
