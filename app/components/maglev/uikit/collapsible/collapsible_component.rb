# frozen_string_literal: true

module Maglev
  module Uikit
    module Collapsible
      class CollapsibleComponent < Maglev::Uikit::BaseComponent
        renders_many :items, 'Maglev::Uikit::Collapsible::ItemComponent'
      end
    end
  end
end
