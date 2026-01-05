# frozen_string_literal: true

module Maglev
  module Content
    class PageContent
      include ActiveModel::Model

      attr_accessor :page, :theme, :stores

      def initialize(page:, theme:, stores:)
        @page = page
        @theme = theme
        @stores = Maglev::Content::StoreContent::AssociationProxy.new(page: page, theme: theme, stores: stores)
      end

      def find_store(id)
        stores[id.to_s]
      end

      def single_store?
        stores.size == 1
      end

      def first_page_store(layout_id)
        theme.find_layout(layout_id).find_page_stores.first.id
      end

      def sections
        stores.map(&:sections).flatten
      end

      def sections_of(handle)
        stores[handle.to_s].sections
      end

      def find_section(id)
        sections.find { |section| section.id == id }
      end

      def sticky_section_ids
        sections.select(&:sticky?).map(&:id)
      end

      def mirrored_section_ids
        sections.select(&:mirrored?).map(&:id)
      end
    end
  end
end
