# frozen_string_literal: true

module Maglev
  module Editor
    module LinksHelper
      def grouped_section_options_for_select(sections)
        grouped_options_for_select(
          sections.map do |section|
            [
              section[:label],
              section[:id],
              section[:layout_store_label]
            ]
          end.group_by(&:pop)
        )
      end
    end
  end
end
