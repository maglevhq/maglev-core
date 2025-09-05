# frozen_string_literal: true

module Maglev
  module Uikit
    module Breadcrumbs
      class LinkComponent < Maglev::Uikit::BaseComponent
        attr_reader :label, :url, :icon

        def initialize(label:, url: nil, icon: nil)
          @label = label
          @icon = icon
          @url = url
        end

        def url?
          url.present?
        end

        def icon?
          icon.present?
        end
      end
    end
  end
end
