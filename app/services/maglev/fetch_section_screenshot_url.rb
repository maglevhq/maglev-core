# frozen_string_literal: true

module Maglev
  class FetchSectionScreenshotUrl
    include Injectable

    dependency :fetch_section_screenshot_path
    argument :section

    def call
      fetch_section_screenshot_path.call(section: section) + "?#{section.screenshot_timestamp}"
    end
  end
end
