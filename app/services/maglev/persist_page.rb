# frozen_string_literal: true

module Maglev
  class PersistPage
    include Injectable

    dependency :fetch_theme

    argument :page
    argument :page_attributes
    argument :site
    argument :site_attributes, default: nil
    argument :theme, default: nil

    def call
      ActiveRecord::Base.transaction do
        persist_page!
        persist_site!
        persist_style!
        page
      end
    end

    private

    def persist_page!
      page.attributes = page_attributes
      page.prepare_sections
      page.save!
    end

    def persist_site!
      return unless can_persist_site?

      site.attributes = site_attributes_with_consistent_sections
      site.prepare_sections
      site.save!
    end

    def persist_style!
      return if site_attributes&.dig(:style).blank?

      site.style = site_attributes[:style]
      site.save!
    end

    def theme
      @theme ||= fetch_theme.call
    end

    # unlike the pages, we don't want to erase
    # the other global sections of a site if they're missing
    # from the site_attributes
    def site_attributes_with_consistent_sections
      attributes = site_attributes.dup

      site.sections&.each do |section|
        next if site_section_types.include?(section['type'])

        attributes[:sections].push(section)
      end

      attributes
    end

    def site_section_types
      @site_section_types ||= site_attributes[:sections].map { |section| section[:type] }
    end

    def can_persist_site?
      site_attributes.present? && site_attributes[:sections].present?
    end
  end
end
