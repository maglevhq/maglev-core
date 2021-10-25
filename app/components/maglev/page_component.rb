# frozen_string_literal: true

module Maglev
  class PageComponent < BaseComponent
    attr_reader :site, :theme, :page, :page_sections, :templates_root_path

    # rubocop:disable Lint/MissingSuper
    def initialize(site:, theme:, page:, page_sections:, templates_root_path:)
      @site = site
      @theme = theme
      @page = page
      @page_sections = page_sections
      @templates_root_path = templates_root_path
    end
    # rubocop:enable Lint/MissingSuper

    # Sections within a dropzone
    def sections
      @sections ||= page_sections.map do |attributes|
        definition = theme.sections.find(attributes['type'])
        next unless definition

        build_section(definition, attributes)
      end.compact
    end

    def render
      sections.collect(&:render).join
    end

    private

    def build_section(definition, attributes)
      build(
        SectionComponent,
        parent: self,
        definition: definition,
        attributes: attributes.deep_transform_keys! { |k| k.to_s.underscore.to_sym },
        templates_root_path: @templates_root_path
      )
    end
  end
end
