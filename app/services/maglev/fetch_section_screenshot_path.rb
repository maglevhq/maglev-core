# frozen_string_literal: true

module Maglev
  class FetchSectionScreenshotPath
    include Injectable

    dependency :fetch_sections_path
    argument :theme, default: nil
    argument :section
    argument :absolute, default: false

    def call
      path = "#{fetch_sections_path.call(theme: theme)}/#{section.category}/#{section.id}.jpg"
      absolute ? Rails.root.join("public/#{path}").to_s : "/#{path}"
    end
  end
end
