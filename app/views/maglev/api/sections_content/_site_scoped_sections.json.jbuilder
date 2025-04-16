# frozen_string_literal: true

site_scoped_sections.each do |type, sections|
  json.set! type do
    json.key_format! camelize: :lower
    json.deep_format_keys!

    json.sections sections
  end
end
