# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::SettingTypes::Hint < Maglev::SettingTypes::Base
  def cast_value(_value)
    nil
  end
end
# rubocop:enable Style/ClassAndModuleChildren
