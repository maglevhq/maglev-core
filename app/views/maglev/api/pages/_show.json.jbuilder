# frozen_string_literal: true

json.key_format! camelize: :lower
json.deep_format_keys!

json.id    page.id
json.title page.title || page.default_title
json.path  page.path || page.default_path
json.path_hash page.path_hash
json.visible page.visible

json.seo_title page.seo_title
json.meta_description page.meta_description
json.og_title page.og_title
json.og_description page.og_description
json.og_image_url page.og_image_url

json.preview_url services.get_page_fullpath.call(page: page, preview_mode: true, locale: content_locale)
json.live_url services.get_page_fullpath.call(page: page, preview_mode: false, locale: content_locale)
json.section_names services.get_page_section_names.call(page: page)
json.sections services.get_page_sections.call(page: page)
json.lock_version page.lock_version
json.translated page.path.present?
