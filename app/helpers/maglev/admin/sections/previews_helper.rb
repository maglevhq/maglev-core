# frozen_string_literal: true

module Maglev
  module Admin
    module Sections
      module PreviewsHelper
        def theme_path
          admin_theme_path
        end

        def create_section_screenshot_path(section)
          admin_sections_screenshots_path(section.id)
        end

        def section_iframe_preview_in_iframe_path(section)
          admin_sections_preview_in_frame_path(section.id)
        end
      end
    end
  end
end
