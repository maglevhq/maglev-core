# frozen_string_literal: true

module Maglev
  module Uikit
    module Form
      module Richtext
        class BlockButtonComponent < ViewComponent::Base
          def choices
            [
              { name: 'paragraph', icon: 'text_paragraph' },
              { name: 'heading_2', icon: 'text_heading_2' },
              { name: 'heading_3', icon: 'text_heading_3' },
              { name: 'heading_4', icon: 'text_heading_4' },
              { name: 'blockquote', icon: 'text_quote' },
              { name: 'code_block', icon: 'text_code' }
            ]
          end
        end
      end
    end
  end
end
