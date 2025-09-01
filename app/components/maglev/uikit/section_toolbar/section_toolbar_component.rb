# frozen_string_literal: true

module Maglev
  module Uikit
    module SectionToolbar
      class SectionToolbarComponent < ViewComponent::Base
        attr_reader :id, :label, :paths, :options

        def initialize(id:, label:, paths:, options: {})
          @id = id
          @label = label
          @paths = paths
          @options = options
        end
      end
    end
  end
end
