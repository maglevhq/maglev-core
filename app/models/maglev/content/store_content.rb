module Maglev
  module Content
    class StoreContent
      include ActiveModel::Model

      attr_accessor :id, :theme, :layout_id, :sections, :lock_version

      def initialize(id:, sections:, lock_version:, theme:, layout_id:)
        @id = id
        @sections = sections
        @lock_version = lock_version
        @theme = theme
        @layout_id = layout_id
      end

      def label
        ::I18n.t("maglev.themes.#{theme.id}.layouts.#{layout_id}.stores.#{id}", default: definition.label)
      end

      def to_param
        id
      end

      # return the definitions of sections that can be added to the store
      def addable_sections
        inserted_section_types = sections.map(&:type)

        theme.sections.select do |section|
          already_inserted = inserted_section_types.include?(section.id)

          # you can't have more than one instance of a recoverable section within a store
          next false if definition.recoverable.include?(section.id) && already_inserted

          # you can't add a siteScoped section if there is already a siteScoped section of the same type
          next false if section.site_scoped? && already_inserted

          # you can't add a singleton section if there is already a singleton section of the same type
          next false if section.singleton? && already_inserted

          # deals with the accept rules of the layout group
          definition.accepts?(section)          
        end
      end

      private

      def definition
        theme.find_layout(layout_id).find_group(id)
      end

      ## class methods ##

      def self.build_many(stores:, theme:, layout_id:)
        stores.map do |store|
          build(store: store, theme: theme, layout_id: layout_id)
        end
      end

      def self.build(store:, theme:, layout_id:)
        StoreContent.new(
            id: store[:id], 
            sections: Maglev::Content::SectionContent.build_many(
              theme: theme, 
              store_handle: store[:id],
              content: store[:sections]
            ), 
            lock_version: store[:lock_version],
            layout_id: layout_id,
            theme: theme
          )
      end
    
      class AssociationProxy
        include Enumerable

        attr_reader :page, :theme, :stores

        delegate :size, :last, to: :stores

        def initialize(page:, theme:, stores:)
          @theme = theme
          @stores = StoreContent.build_many(stores: stores, theme: theme, layout_id: page.layout_id)
        end
        
        def [](id)
          stores.find { |store| store.id == id }
        end

        def each(&block)
          stores.each(&block)
        end        
      end
    end
  end
end