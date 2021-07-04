# frozen_string_literal: true

module Maglev
  class ClonePage
    include Injectable

    argument :page

    def call
      return nil unless page.persisted?

      create_page!
    end

    private

    def create_page!
      Maglev::Page.create!(
        title: "#{page.title} COPY",
        path: "#{page.path}-#{generate_clone_code(4)}",
        sections: page.sections
      )
    end

    def generate_clone_code(number)
      charset = Array('A'..'Z') + Array('a'..'z')
      Array.new(number) { charset.sample }.join
    end
  end
end
