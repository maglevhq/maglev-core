# frozen_string_literal: true

module Maglev
  module SpecHelpers
    module SectionsContentHelper
      def fetch_sections_content(store_handle)
        Maglev::SectionsContentStore
          .find_by(handle: store_handle)
          .sections
      end

      def section_types(store_handle)
        fetch_sections_content(store_handle).map { |section| section['type'] }
      end
    end
  end
end
