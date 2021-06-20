# frozen_string_literal: true

module Maglev
  class PersistPage
    include Injectable

    dependency :fetch_site
    dependency :fetch_theme

    argument :page
    argument :attributes
    argument :site, default: nil
    argument :theme, default: nil

    def call
      page.attributes = attributes
      page.prepare_sections
      page.save!

      site.save! if can_persist_site_scoped_sections? && assign_site_scoped_sections

      page
    end

    private

    def can_persist_site_scoped_sections?
      page.sections.any? do |section|
        definition = theme.sections.find(section['type'])
        next unless definition&.scoped_by_site?

        section.key?('settings') || section.key?('blocks')
      end
    end

    def assign_site_scoped_sections
      page.sections.any? do |section|
        definition = theme.sections.find(section['type'])
        next unless definition.scoped_by_site?

        site.add_section(section)
        true
      end
    end

    def site
      @site ||= fetch_site.call
    end

    def theme
      @theme ||= fetch_theme.call
    end
  end
end
