# frozen_string_literal: true

json.key_format! camelize: :lower
json.deep_format_keys!
json.call(theme, :id, :name, :description)
json.sections theme.sections do |section|
  json.call(section, :id, :name, :category, :site_scoped, :singleton, :viewport_fixed_position,
            :insert_button, :insert_at, :max_width_pane,
            :blocks_label, :blocks_presentation, :sample)
  json.settings section.settings.as_json
  json.blocks section.blocks.as_json
  json.theme_id theme.id
  json.screenshot_path services.fetch_section_screenshot_url.call(section: section)
end
json.section_categories theme.section_categories.as_json
json.icons theme.icons || []
json.style_settings theme.style_settings.as_json
json.mirror_section theme.mirror_section
json.layouts theme.layouts do |layout|
  json.call(layout, :id, :label)
  json.groups layout.groups do |group|
    json.call(group, :id, :label, :store, :accept, :recoverable)
    json.mirror_section group.mirror_section == false ? false : theme.mirror_section
  end
end
