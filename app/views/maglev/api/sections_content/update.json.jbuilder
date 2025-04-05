# frozen_string_literal: true

json.key_format! camelize: :lower
json.deep_format_keys!

json.lock_versions(@stores.transform_values(&:lock_version))
