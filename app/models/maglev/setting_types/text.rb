# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::SettingTypes::Text < Maglev::SettingTypes::Base
  def default_for(label:, default:)
    default.presence || label
  end
end
# rubocop:enable Style/ClassAndModuleChildren
