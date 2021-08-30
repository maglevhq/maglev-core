# frozen_string_literal: true

module Maglev
  module PagePreviewHelper
    # rubocop:disable Rails/OutputSafety
    def render_maglev_sections(site: nil, theme: nil, page: nil, page_sections: nil)
      PageComponent.new(
        site: site || maglev_site,
        theme: theme || maglev_theme,
        page: page || maglev_page,
        page_sections: page_sections || maglev_page_sections,
        templates_root_path: maglev_sections_path
      ).tap { |component| component.view_context = self }.render.html_safe
    end
    # rubocop:enable Rails/OutputSafety

    def render_maglev_section(type, site: nil, theme: nil, page: nil, page_sections: nil)
      render_maglev_sections(
        site: site,
        theme: theme,
        page: page,
        page_sections: (page_sections || maglev_page_sections).find_all { |section| section['type'] == type.to_s }
      )
    end
  end
end
