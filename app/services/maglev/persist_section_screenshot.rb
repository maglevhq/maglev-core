# frozen_string_literal: true

require 'tempfile'

module Maglev
  # Used to create a screenshot of a section from the Maglev admin UI.
  class PersistSectionScreenshot
    include Injectable

    dependency :fetch_theme
    dependency :fetch_section_screenshot_path

    argument :section_id
    argument :base64_image

    def call
      return false if base64_image.blank?

      image_data = Base64.decode64(
        base64_image['data:image/png;base64,'.length..]
      )

      persist_file(image_data)

      section.screenshot_timestamp = Time.now.to_i

      true
    end

    private

    def persist_file(image_data)
      tmp_file = Tempfile.new(File.basename(screenshots_dir), binmode: true)
      tmp_file.write(image_data)
      tmp_file.close

      # PNG -> JPG to lower the size of the image
      ::ActiveStorage::Variation.new(format: 'jpg', saver: { quality: 90 }).transform(tmp_file) do |output|
        FileUtils.mkdir_p(screenshots_dir)
        File.open(screenshot_filepath, 'wb') do |f|
          f.write(output.read)
        end
      end
    end

    def section
      @section ||= fetch_theme.call.sections.find(section_id)
    end

    def screenshot_filepath
      fetch_section_screenshot_path.call(section: section, absolute: true)
    end

    def screenshots_dir
      File.dirname(screenshot_filepath)
    end
  end
end
