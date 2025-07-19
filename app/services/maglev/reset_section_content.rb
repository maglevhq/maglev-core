# frozen_string_literal: true

module Maglev
  # Reset the content of a section type across a site and its pages
  class ResetSectionContent
    include Injectable

    argument :site
    argument :theme
    argument :type

    def call
      validate_section_type!

      @count = 0

      reset_content

      @count
    end

    private

    def validate_section_type!
      return if theme.sections.find(type)

      raise Maglev::Errors::UnknownSection,
            "Section type '#{type}' doesn't exist in the theme"
    end

    def reset_content
      ActiveRecord::Base.transaction do
        reset_resource_content(site)
        site_pages.find_each do |page|
          reset_resource_content(page)
        end
      end
    end

    def reset_resource_content(resource)
      site.each_locale do
        @count += reset_sections_content_of_type(resource.find_sections_by_type(type), type)
      end

      resource.save!
    end

    def reset_sections_content_of_type(sections, type)
      return 0 if sections.blank?

      sections.map do |section|
        section.replace(build_default_content(type))
      end.size
    end

    def build_default_content(type)
      theme.sections.find(type).build_default_content
    end

    def site_pages
      Maglev::Page
    end
  end
end
