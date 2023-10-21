# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::SettingTypes::Link < Maglev::SettingTypes::Base
  def cast_value(value)
    if value.is_a?(String)
      { text: 'Link', link_type: 'url', href: value }
    else
      { text: 'Link', link_type: 'url', href: '#' }.merge(value)
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
