# frozen_string_literal: true

module Maglev
  class SetupPages
    include Injectable

    argument :theme
    argument :extra_attributes, default: {}

    def call
      theme&.pages&.map do |attributes|
        page = Maglev::Page.new(attributes.merge(extra_attributes))
        page.prepare_sections
        page.save!
        page
      end
    end
  end
end
