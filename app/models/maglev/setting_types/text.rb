# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Maglev::SettingTypes::Text < Maglev::SettingTypes::Base
  def content_label(value)
    return nil if value.blank?

    Nokogiri::HTML(value.gsub(%r{<br/?>}, ' ')).text.strip
  end
end
# rubocop:enable Style/ClassAndModuleChildren
