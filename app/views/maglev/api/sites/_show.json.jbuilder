json.key_format! camelize: :lower
json.deep_format_keys!
json.call(site, :id, :home_page_id)
json.settings([{ some_value: [{ other_value: 'abc' }] }])
