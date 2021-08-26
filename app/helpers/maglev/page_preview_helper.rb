# frozen_string_literal: true

module Maglev
  module PagePreviewHelper
    def render_maglev_sections(site: nil, theme: nil, page: nil, page_sections: nil)
      PageComponent.new(
        site: site || @site,
        theme: theme || @theme,
        page: page || @page,
        page_sections: page_sections || @page_sections,
        templates_root_path: fetch_sections_path
      ).tap { |component| component.view_context = self }.render.html_safe
    end

    def render_maglev_section(type, site: nil, theme: nil, page: nil, page_sections: nil)
      render_maglev_sections(
        site: site, 
        theme: theme, 
        page: page, 
        page_sections: (page_sections || @page_sections).find_all { |section| section['type'] == type.to_s }
      )
    end
  end
end
