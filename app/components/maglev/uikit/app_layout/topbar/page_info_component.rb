# frozen_string_literal: true

module Maglev
  module Uikit
    module AppLayout
      module Topbar
        class PageInfoComponent < ViewComponent::Base
          attr_reader :page, :paths, :live_page_url, :prefix_page_path

          def initialize(page:, paths:, live_page_url:, prefix_page_path:)
            @page = page
            @paths = paths
            @live_page_url = live_page_url
            @prefix_page_path = prefix_page_path
          end

          def icon_name
            page.index? ? 'home' : 'file'
          end

          def page_path
            "#{prefix_page_path}#{page.path.presence || page.default_path}"
          end
        end
      end
    end
  end
end
