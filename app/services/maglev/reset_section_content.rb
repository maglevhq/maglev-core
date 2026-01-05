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
        scoped_stores.unpublished.find_each do |store|
          reset_resource_content(store)
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

    def scoped_stores
      Maglev::SectionsContentStore
    end
  end
end
