# frozen_string_literal: true

module Maglev
  class PersistSectionScreenshot
    include Injectable

    argument :screenshot_path
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

    def screenshot_filepath
      Rails.root.join("public/#{screenshot_path}")
    end

    def screenshots_dir
      File.dirname(screenshot_filepath)
    end
  end
end
