# frozen_string_literal: true

module Maglev
  module SpecHelpers
    module SectionsContentHelper
      def fetch_sections_translations(handle, page_id = nil)
        Maglev::SectionsContentStore
          .find_by(handle: handle, maglev_page_id: page_id, published: false)
          .sections_translations
      end

      def fetch_sections_store(handle, page_id = nil)
        Maglev::SectionsContentStore
          .find_by(handle: handle, maglev_page_id: page_id, published: false)
      end

      def fetch_sections_content(handle, page_id = nil)
        fetch_sections_store(handle, page_id).sections
      end

      def section_types(handle, page_id = nil)
        fetch_sections_content(handle, page_id).map { |section| section['type'] }
      end
    end
  end
end
