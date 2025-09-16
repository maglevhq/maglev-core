# frozen_string_literal: true

module Maglev
  module Inputs
    module CollectionItem
      class CollectionItemComponent < Maglev::Inputs::InputBaseComponent
        def selected_item_id
          value.fetch('id', nil)
        end

        def selected_item_label
          value.fetch('label', nil)
        end
      end
    end
  end
end
