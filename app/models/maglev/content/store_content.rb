# frozen_string_literal: true

module Maglev
  module Content
    class StoreContent
      include ActiveModel::Model

      attr_accessor :handle, :theme, :layout_id, :sections, :lock_version

      def initialize(handle:, sections:, lock_version:, theme:, layout_id:)
        @handle = handle
        @sections = sections
        @lock_version = lock_version
        @theme = theme
        @layout_id = layout_id
      end

      def label
        definition.human_name
      end

      def to_param
        handle
      end

      def allow_mirrored_sections?
        theme.mirror_section? && definition.mirror_section?
      end

      # return the definitions of sections that can be added to the store
      def addable_sections
        inserted_section_types = sections.map(&:type)

        theme.sections.select do |section|
          already_inserted = inserted_section_types.include?(section.id)

          section.can_be_added_in?(definition, already_inserted)
        end
      end

      def can_add_sections?
        addable_sections.any?
      end

      ## class methods ##

      def self.build_many(stores:, theme:, layout_id:)
        stores.map do |store|
          build(store: store, theme: theme, layout_id: layout_id)
        end
      end

      def self.build(store:, theme:, layout_id:)
        StoreContent.new(
          handle: store[:handle],
          sections: build_sections(store: store, theme: theme),
          lock_version: store[:lock_version],
          layout_id: layout_id,
          theme: theme
        )
      end

      def self.build_sections(store:, theme:)
        Maglev::Content::SectionContent.build_many(
          theme: theme,
          store_handle: store[:handle],
          content: store[:sections]
        )
      end

      private

      def definition
        theme.find_layout(layout_id).find_group(handle)
      end

      class AssociationProxy
        include Enumerable

        attr_reader :page, :theme, :stores

        delegate :size, :last, to: :stores

        def initialize(page:, theme:, stores:)
          @theme = theme
          @stores = StoreContent.build_many(stores: stores, theme: theme, layout_id: page.layout_id)
        end

        def [](handle)
          stores.find { |store| store.handle == handle }
        end

        def each(&block)
          stores.each(&block)
        end
      end
    end
  end
end
