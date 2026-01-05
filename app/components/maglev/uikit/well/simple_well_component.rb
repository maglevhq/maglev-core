# frozen_string_literal: true

module Maglev
  module Uikit
    module Well
      class SimpleWellComponent < ViewComponent::Base
        renders_one :title
        renders_one :description
        renders_one :action
      end
    end
  end
end
