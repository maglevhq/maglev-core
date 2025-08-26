# frozen_string_literal: true

module Maglev
  module Uikit
    module AppLayout
      class TopbarComponent < ViewComponent::Base
        renders_one :logo, -> { Maglev::Uikit::AppLayout::Topbar::LogoComponent.new(root_path: root_path) }
        renders_one :page_info
        renders_one :actions

        attr_reader :page, :root_path

        def initialize(page:, root_path:)
          @page = page
          @root_path = root_path
        end
      end
    end
  end
end
