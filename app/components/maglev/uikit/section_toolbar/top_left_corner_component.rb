# frozen_string_literal: true

module Maglev
  module Uikit
    module SectionToolbar
      class TopLeftCornerComponent < Maglev::Uikit::BaseComponent
        attr_reader :label

        def initialize(label:)
          @label = label
        end
      end
    end
  end
end
