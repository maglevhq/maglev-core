# frozen_string_literal: true

json.key_format! camelize: :lower
json.deep_format_keys!

json.array! sections_content do |group|
  json.id group[:id]
  json.sections group[:sections]
  json.lock_version group[:lock_version]
end
