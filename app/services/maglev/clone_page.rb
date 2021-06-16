# frozen_string_literal: true

module Maglev
  class ClonePage
    include Injectable

    argument :page
    argument :extra_attributes, default: {}

    def call
      return nil unless page.persisted?

      Maglev::Page.create!(
        extra_attributes.reverse_merge(
          title: "#{page.title} COPY",
          path: "#{page.path}-#{generate_clone_code(4)}",
          sections: page.sections
        )
      )
    end

    private

    def generate_clone_code(number)
      charset = Array('A'..'Z') + Array('a'..'z')
      Array.new(number) { charset.sample }.join
    end
  end
end
