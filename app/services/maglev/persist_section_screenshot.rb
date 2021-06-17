# frozen_string_literal: true

module Maglev
  class PersistSectionScreenshot
    include Injectable

    dependency :fetch_theme
    dependency :fetch_sections_path
    dependency :fetch_screenshot_path

    argument :section_id
    argument :base64_image

    def call
      return false if base64_image.blank?

      image_data = Base64.decode64(
        base64_image['data:image/png;base64,'.length..]
      )

      FileUtils.mkdir_p(screenshots_dir)
      File.open(screenshot_filepath, 'wb') do |f|
        f.write(image_data)
      end

      true
    end

    private

    def section
      @section ||= fetch_theme.call.sections.find(section_id)
    end

    def screenshot_filepath
      fetch_screenshot_path.call(section: section)
    end

    def screenshots_dir
      File.dirname(screenshot_filepath)
    end
  end
end
