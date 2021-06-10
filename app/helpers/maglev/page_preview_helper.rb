# frozen_string_literal: true

module Maglev
  module PagePreviewHelper
    def render_maglev_sections(site:, theme:, page:, page_sections:)
      PageComponent.new(
        site: site,
        theme: theme,
        page: page,
        page_sections: page_sections,
        templates_root_path: templates_root_path
      ).tap { |component| component.view_context = self }.render
    end
  end
end
