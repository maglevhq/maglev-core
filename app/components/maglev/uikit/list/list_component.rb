# frozen_string_literal: true

module Maglev
  module Uikit
    module List
      class ListComponent < Maglev::Uikit::BaseComponent
        renders_many :items, types: {
          content: Maglev::Uikit::List::ListItemComponent,
          insert_button: Maglev::Uikit::List::InsertButtonComponent
        }

        attr_reader :sort_form

        def initialize(sort_form: nil)
          @sort_form = sort_form
        end

        def sort_form_path
          sort_form&.fetch(:path)
        end

        def sort_form_data
          { sortable_target: 'sortableForm' }.merge(sort_form[:data] || {})
        end

        def sortable?
          sort_form_path.present?
        end
      end
    end
  end
end
