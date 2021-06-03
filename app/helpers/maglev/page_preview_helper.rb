# frozen_string_literal: true

module Maglev
  module PagePreviewHelper
    def render_maglev_sections(site:, theme:, page:, page_sections:)
      PageComponent.new(site: site, theme: theme, page: page, page_sections: page_sections).tap do |component|
        component.view_context = self
      end.render
    end
  end
end
