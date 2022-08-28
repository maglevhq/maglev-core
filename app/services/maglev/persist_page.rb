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

      # lock_version can be nil when we setup a brand new site
      site.lock_version = site_attributes[:lock_version] if site_attributes[:lock_version]
      site_attributes[:sections].each do |section|
        site.add_section(section)
      end
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

    def can_persist_site?
      site_attributes.present? && site_attributes[:sections].present?
    end
  end
end
