# frozen_string_literal: true

json.key_format! camelize: :lower
json.deep_format_keys!

json.sections site.sections

json.call(site, *site.api_attributes)
json.home_page_id home_page_id
