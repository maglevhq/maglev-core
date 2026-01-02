module Maglev
  module Editor
    module MirroredSectionsHelper
      def grouped_section_options_for_select(sections)
        grouped_options_for_select(
          sections.map do |section|
            [
              section[:label], [section[:layout_store_id], section[:type], section[:id]].join('/'), 
              section[:layout_store_label]
            ]
          end.group_by { |array| array.pop }
        )
      end
    end
  end
end