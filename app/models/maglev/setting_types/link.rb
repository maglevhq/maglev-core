# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::SettingTypes::Link < Maglev::SettingTypes::Base
  def cast_value(value)
    if value.is_a?(String)
      { text: 'Link', link_type: 'url', href: value }
    elsif value
      { text: 'Link', link_type: 'url', href: '#' }.merge(value.symbolize_keys)
    end
  end

  def content_label(value)
    value&.fetch('text', nil)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
