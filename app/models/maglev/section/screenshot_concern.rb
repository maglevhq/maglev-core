# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
module Maglev::Section::ScreenshotConcern
  def screenshot_path
    "/theme/#{id}.png" if File.exist?(screenshot_filepath)
  end

  def create_screenshot(base64_image)
    FileUtils.mkdir_p(File.dirname(screenshot_filepath))

    image_data = Base64.decode64(
      base64_image['data:image/png;base64,'.length..-1]
    )

    File.open(screenshot_filepath, 'wb') do |f|
      f.write(image_data)
    end
  end

  private

  def screenshots_dir
    Rails.root.join('public/theme')
  end

  def screenshot_filepath
    File.join(screenshots_dir.to_s, "#{id}.png")
  end
end
# rubocop:enable Style/ClassAndModuleChildren
