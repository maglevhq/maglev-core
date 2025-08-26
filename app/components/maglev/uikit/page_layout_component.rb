# frozen_string_literal: true

module Maglev
  module Uikit
    class PageLayoutComponent < Maglev::Uikit::BaseComponent
      renders_one :title
      renders_one :description
      renders_one :notification
      renders_one :footer

      attr_reader :back_path

      def initialize(back_path: nil)
        @back_path = back_path
      end
    end
  end
end
