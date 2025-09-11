# frozen_string_literal: true

module Maglev
  module Uikit
    module Form
      module Richtext
        class ButtonGroupComponent < ViewComponent::Base
          renders_many :buttons, 'Maglev::Uikit::Form::Richtext::ButtonComponent'
        end
      end
    end
  end
end
