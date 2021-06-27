# frozen_string_literal: true

json.sections services.get_page_sections.call(page: @page)

json.key_format! camelize: :lower
json.deep_format_keys!

json.id    @page.id
json.title @page.title
json.path  @page.path
json.visible @page.visible
json.seo_title @page.seo_title
json.meta_description @page.meta_description
json.preview_url services.get_page_fullpath.call(page: @page, preview_mode: true)
json.section_names services.get_page_section_names.call(page: @page)
