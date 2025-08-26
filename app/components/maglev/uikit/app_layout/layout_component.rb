# frozen_string_literal: true

module Maglev
  module Uikit
    module AppLayout
      class LayoutComponent < ViewComponent::Base
        renders_one :topbar, -> { Maglev::Uikit::AppLayout::TopbarComponent.new(page: page, root_path: root_path) }
        renders_one :sidebar, -> { Maglev::Uikit::AppLayout::SidebarComponent.new }

        attr_reader :page, :root_path

        def initialize(page:, root_path:)
          @page = page
          @root_path = root_path
        end
      end
    end
  end
end
