# frozen_string_literal: true

module Maglev
  module Uikit
    module AppLayout
      module Topbar
        class LogoComponent < ViewComponent::Base
          attr_reader :root_path

          def initialize(root_path:)
            @root_path = root_path
          end
        end
      end
    end
  end
end
