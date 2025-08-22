# frozen_string_literal: true

module Maglev
  class FetchSectionScreenshotUrl
    include Injectable

    dependency :fetch_section_screenshot_path
    argument :section

    def call
      screenshot_path = fetch_section_screenshot_path.call(section: section) + query_string
      asset_host ? URI.join(asset_host, screenshot_path).to_s : screenshot_path
    end

    private

    def asset_host
      Rails.application.config.asset_host
    end

    def query_string
      "?#{section.screenshot_timestamp}"
    end
  end
end
