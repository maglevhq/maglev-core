# frozen_string_literal: true

module Maglev
  # Remove all sections of a specific type across a site and its pages
  class RemoveSectionType
    include Injectable

    argument :site
    argument :type

    def call
      @removed_count = 0

      remove_sections

      @removed_count
    end

    private

    def remove_sections
      ActiveRecord::Base.transaction do
        resources.find_each do |resource|
          remove_resource_sections(resource)
        end
      end
    end

    def remove_resource_sections(resource)
      site.each_locale do
        @removed_count += remove_sections_of_type(resource.sections, type)
      end

      resource.save!
    end

    def remove_sections_of_type(sections, type)
      return 0 if sections.blank?

      original_size = sections.size
      sections.reject! { |section| section['type'] == type }
      original_size - sections.size
    end

    def resources
      Maglev::SectionsContentStore.all
    end
  end
end
