# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::SettingTypes::CollectionItem < Maglev::SettingTypes::Base
  def cast_value(value)
    if value.is_a?(String)
      { id: value }
    else
      value
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
