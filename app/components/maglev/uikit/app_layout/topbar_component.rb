# frozen_string_literal: true

module Maglev
  module Uikit
    module AppLayout
      class TopbarComponent < ViewComponent::Base
        renders_one :logo, -> { Maglev::Uikit::AppLayout::Topbar::LogoComponent.new(page: page) }
        renders_one :page_info
        renders_one :actions

        attr_reader :page

        def initialize(page:)
          @page = page
        end
      end
    end
  end
end
