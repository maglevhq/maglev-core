# frozen_string_literal: true

module Maglev
  module Uikit
    module Form
      module Combobox
        class ListComponent < ViewComponent::Base
          renders_many :options, 'Maglev::Uikit::Form::Combobox::OptionComponent'
        end
      end
    end
  end
end
