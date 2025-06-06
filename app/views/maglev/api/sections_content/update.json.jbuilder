# frozen_string_literal: true

json.key_format! camelize: :lower
json.deep_format_keys!

json.lock_versions(@stores.transform_values(&:lock_version).to_a.map do |(layout_group_id, lock_version)|
  { layout_group_id: layout_group_id, lock_version: lock_version }
end)
