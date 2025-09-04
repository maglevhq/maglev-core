# frozen_string_literal: true

module Maglev
  module Inputs
    module Forms
      class SectionFormComponent < ViewComponent::Base
        attr_reader :section, :path

        def initialize(section:, path:)
          @section = section
          @path = path
        end
      end
    end
  end
end
