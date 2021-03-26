# frozen_string_literal: true

json.sections @page.sections

json.key_format! camelize: :lower
json.deep_format_keys!
json.id    @page.id
json.title @page.title
json.path  @page.path
json.preview_url site_preview_url(path: @page.path)
