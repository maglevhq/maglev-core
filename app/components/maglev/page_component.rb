# frozen_string_literal: true

module Maglev
  class PageComponent < BaseComponent
    attr_reader :site, :theme, :page

    def initialize(site:, theme:, page:)
      @site = site
      @theme = theme
      @page = page
    end

    # Sections within a dropzone
    def sections
      @sections ||= page.sections.map do |attributes|
        build(
          SectionComponent,
          parent: self,
          definition: theme.sections.find(attributes['type']),
          attributes: attributes.deep_transform_keys! { |k| k.underscore.to_sym }
        )
      end
    end

    def render
      sections.collect(&:render).join
    end
  end
end
