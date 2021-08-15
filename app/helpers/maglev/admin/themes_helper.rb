# frozen_string_literal: true

module Maglev
  module Admin
    module ThemesHelper
      def section_category_path(category)
        admin_theme_path(category_id: category.id)
      end

      def section_preview_path(section)
        admin_sections_preview_path(section.id)
      end

      def section_file_path(section)
        "<RailsRoot>/app/theme/sections/#{section.id}.yml"
      end

      def section_template_path(section)
        "<RailsRoot>/app/views/theme/sections/#{section.id}.html.erb"
      end

      def section_screenshot_path(section)
        services.fetch_section_screenshot_path.call(section: section)
      end
    end
  end
end
