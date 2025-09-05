# frozen_string_literal: true

module Maglev
  module Uikit
    module Breadcrumbs
      class BreadcrumbsComponent < Maglev::Uikit::BaseComponent
        renders_many :breadcrumbs, 'Maglev::Uikit::Breadcrumbs::LinkComponent'
      end
    end
  end
end
