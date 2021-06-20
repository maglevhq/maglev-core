# frozen_string_literal: true

json.key_format! camelize: :lower
json.deep_format_keys!
json.call(theme, :id, :name, :description)
json.sections theme.sections do |section|
  json.call(section, :id, :name, :category, :scope, :settings, :blocks, :blocks_label, :blocks_presentation)
  json.theme_id theme.id
  json.screenshot_path services.fetch_screenshot_path.call(section: section)
end
json.section_categories theme.section_categories.as_json
