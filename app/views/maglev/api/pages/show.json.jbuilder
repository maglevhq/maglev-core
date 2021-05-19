# frozen_string_literal: true

json.sections @page.sections_for_editing

json.key_format! camelize: :lower
json.deep_format_keys!

json.id    @page.id
json.title @page.title
json.path  @page.path
json.visible @page.visible
json.seo_title @page.seo_title
json.meta_description @page.meta_description
json.preview_url site_preview_url(path: @page.path)
json.section_names @page.section_names
