# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::SettingTypes::Checkbox < Maglev::SettingTypes::Base
  def cast_value(value)
    ActiveModel::Type::Boolean.new.cast(value) || false
  end
end
# rubocop:enable Style/ClassAndModuleChildren
