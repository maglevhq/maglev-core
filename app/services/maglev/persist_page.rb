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
      return if site_attributes.blank?
      site.attributes = site_attributes.slice(:lock_version)
      site_attributes[:sections].each do |section|
        site.add_section(section)
      end
      site.save!
    end   

    def theme
      @theme ||= fetch_theme.call
    end
  end
end
