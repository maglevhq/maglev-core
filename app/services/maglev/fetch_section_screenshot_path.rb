# frozen_string_literal: true

module Maglev
  class FetchSectionScreenshotPath
    include Injectable

    dependency :fetch_sections_path
    argument :theme, default: nil
    argument :section
    argument :absolute, default: false

    def call
      path = "#{base_path}.#{extension}"
      absolute ? Rails.root.join("public/#{path}").to_s : "/#{path}"
    end

    private

    def base_path
      "#{fetch_sections_path.call(theme: theme)}/#{section.category}/#{section.id}"
    end

    def extension
      File.exist?(Rails.root.join("public/#{base_path}.webp")) ? 'webp' : 'jpg'
    end
  end
end
