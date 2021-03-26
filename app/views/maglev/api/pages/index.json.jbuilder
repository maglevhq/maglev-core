# frozen_string_literal: true

json.array! @pages do |page|
  json.id    page.id
  json.title page.title
  json.path  page.path
  json.preview_url site_preview_url(path: page.path)
end
