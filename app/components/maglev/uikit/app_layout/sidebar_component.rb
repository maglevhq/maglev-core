# frozen_string_literal: true

module Maglev
  module Uikit
    module AppLayout
      class SidebarComponent < ViewComponent::Base
        renders_many :links, 'Maglev::Uikit::AppLayout::Sidebar::LinkComponent'
      end
    end
  end
end
