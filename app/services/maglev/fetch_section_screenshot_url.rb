# frozen_string_literal: true

module Maglev
  class FetchSectionScreenshotUrl
    include Injectable

    dependency :fetch_section_screenshot_path
    dependency :context

    argument :section

    def call
      screenshot_path = fetch_section_screenshot_path.call(section: section) + query_string
      asset_host ? URI.join(asset_host, screenshot_path).to_s : screenshot_path
    end

    private

    def asset_host
      host = Rails.application.config.asset_host
      return nil if host.blank?

      host.start_with?('http://', 'https://') ? host : "#{request_protocol}#{host}"
    end

    def query_string
      "?#{section.screenshot_timestamp}"
    end

    def request_protocol
      context.controller.request.protocol
    end
  end
end
