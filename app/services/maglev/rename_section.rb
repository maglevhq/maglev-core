# frozen_string_literal: true

module Maglev
  # Rename a section type across a site and its pages
  class RenameSection
    include Injectable

    argument :site
    argument :theme
    argument :old_type
    argument :new_type

    def call
      validate_section_types!

      ActiveRecord::Base.transaction do
        rename_resource_sections(site)
        site_pages.find_each do |page|
          rename_resource_sections(page)
        end
      end

      true
    end

    private

    def validate_section_types!
      return if theme.sections.find(new_type)

      raise Maglev::Errors::UnknownSection,
            "New section type '#{new_type}' doesn't exist in the theme"
    end

    def rename_resource_sections(resource)
      return unless resource.any_section_of_type?(old_type)

      site.each_locale do |locale|
        Maglev::I18n.with_locale(locale) do
          change_section_type(resource.sections, old_type, new_type)
        end
      end

      resource.save!
    end

    def change_section_type(sections, old_type, new_type)
      sections.each do |section|
        section['type'] = new_type if section['type'] == old_type
      end
    end

    def site_pages
      Maglev::Page
    end
  end
end
