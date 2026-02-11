# frozen_string_literal: true

module Maglev
  module Uikit
    class PaginationComponent < Maglev::Uikit::BaseComponent
      include Pagy::Frontend

      attr_reader :pagy, :hidden_if_single_page

      def initialize(pagy:, item_name: 'item', hidden_if_single_page: true, show_info: true)
        @pagy = pagy
        @hidden_if_single_page = hidden_if_single_page
        @item_name = item_name
        @show_info = show_info
      end

      def item_name
        @item_name.pluralize(@pagy.count)
      end

      def render?
        !(hidden_if_single_page && pagy.pages < 2)
      end

      def show_info?
        @show_info
      end
    end
  end
end
