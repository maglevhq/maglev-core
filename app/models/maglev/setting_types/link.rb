# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::SettingTypes::Link < Maglev::SettingTypes::Base
  def cast_value(value)
    if value.is_a?(String)
      { text: 'Link', link_type: 'url', href: value }
    elsif value
      cast_open_new_window({ text: 'Link', link_type: 'url', href: '#' }.merge(value.symbolize_keys))
    end
  end

  def content_label(value)
    value&.fetch('text', nil)
  end

  private

  # the editor form submits the open_new_window flag as a string ("true", "false" or "")
  def cast_open_new_window(link)
    return link unless link.key?(:open_new_window)

    link.merge(open_new_window: ActiveModel::Type::Boolean.new.cast(link[:open_new_window]) || false)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
