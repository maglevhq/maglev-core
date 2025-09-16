# frozen_string_literal: true

module Maglev
  module Inputs
    module Icon
      class IconComponent < Maglev::Inputs::InputBaseComponent
        # required by the IconLibrary modal when selecting an icon
        def input_source
          input_name.parameterize.underscore
        end
      end
    end
  end
end
