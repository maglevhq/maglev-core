# frozen_string_literal: true

module Maglev
  module Uikit
    module AppLayout
      class LayoutComponent < ViewComponent::Base
        renders_one :topbar, -> { Maglev::Uikit::AppLayout::TopbarComponent.new(page: page) }
        renders_one :sidebar, -> { Maglev::Uikit::AppLayout::SidebarComponent.new }

        attr_reader :page

        def initialize(page:)
          @page = page
        end
      end
    end
  end
end
