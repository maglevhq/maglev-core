# frozen_string_literal: true

module Maglev
  class GetPublishedPageSectionsService
    include Injectable
    
    dependency :get_page_sections

    argument :page
    argument :locale, default: nil

    def call
      get_page_sections.call(page: page, locale: locale, published: true)    
    end
  end
end
