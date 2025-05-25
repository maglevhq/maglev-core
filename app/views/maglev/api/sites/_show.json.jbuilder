# frozen_string_literal: true

json.key_format! camelize: :lower
json.deep_format_keys!

json.sections site.sections || []

json.style services.fetch_style.call(site: site, theme: maglev_theme).as_json

json.locales site.locales

json.call(site, *site.api_attributes)
json.home_page_id home_page_id

json.lock_version site.lock_version
