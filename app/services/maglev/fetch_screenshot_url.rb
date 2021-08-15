# frozen_string_literal: true

module Maglev
  class FetchScreenshotUrl
    include Injectable

    dependency :fetch_screenshot_path
    argument :section

    def call
      fetch_screenshot_path.call(section: section) + "?#{section.screenshot_timestamp}"
    end
  end
end
