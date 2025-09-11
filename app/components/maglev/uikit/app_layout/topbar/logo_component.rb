# frozen_string_literal: true

module Maglev
  module Uikit
    module AppLayout
      module Topbar
        class LogoComponent < ViewComponent::Base
          attr_reader :root_path, :logo_url

          def initialize(root_path:, logo_url:)
            @root_path = root_path
            @logo_url = logo_url
          end
        end
      end
    end
  end
end
