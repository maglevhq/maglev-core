# frozen_string_literal: true

module Maglev
  module Uikit
    module Form
      module Richtext
        class ButtonComponent < ViewComponent::Base
          attr_reader :name, :action_name, :icon

          def initialize(name:, icon:, action_name: nil)
            @name = name
            @action_name = action_name.presence || "toggle#{name.camelize}"
            @icon = icon
          end
        end
      end
    end
  end
end
