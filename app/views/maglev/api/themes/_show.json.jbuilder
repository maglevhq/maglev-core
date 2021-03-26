json.key_format! camelize: :lower
json.deep_format_keys!
json.call(theme, :id, :name, :description)
json.sections theme.sections.as_json
json.section_categories theme.section_categories.as_json
