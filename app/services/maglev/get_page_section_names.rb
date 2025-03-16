# frozen_string_literal: true

module Maglev
  # Get an array of maps including the id and name of each page section.
  class GetPageSectionNames
    include Injectable

    dependency :fetch_theme

    argument :page

    # [
    #   { id: 'abc', name: 'Navbar', layoutGroupLabel: 'Header' },
    #   { id: 'dfdf', name: 'Jumbotron', layoutGroupLabel: 'Main' },
    #   { id: 'gdgg', name: 'BigFooter', layoutGroupLabel: 'Footer' }
    # ]
    def call
      fetch_stores.map do |(store, group_label)|
        store.sections.map do |section|
          definition = theme.sections.find(section['type'])
          { id: section['id'], name: definition.name, layout_group_label: group_label }
        end
      end.flatten
    end

    protected

    def fetch_stores
      handles = layout.groups.inject({}) do |memo, group| 
        memo[group.guess_store_handle(page)] = group.label
        memo
      end
      scoped_store.by_handles(handles.keys).map do |store|
        [store, handles[store.handle]]
      end
    end

    def theme
      @theme ||= fetch_theme.call
    end

    def layout
      theme.find_layout(page.layout_id).tap do |layout|
        raise Maglev::Errors::MissingLayout, "The page #{page.id} misses the layout_id property" if layout.nil?
      end
    end

    def scoped_store
      Maglev::SectionsContentStore
    end
  end
end
