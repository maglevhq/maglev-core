# frozen_string_literal: true

module Maglev
  module Content
    class DeleteSectionService
      include Injectable
      include Maglev::Content::HelpersConcern
      include Maglev::Content::PublishingStateConcern

      dependency :fetch_theme
      dependency :fetch_site

      argument :store
      argument :section_id
      argument :layout_id, default: nil

      def call
        raise Maglev::Errors::UnknownSection unless section_definition

        ActiveRecord::Base.transaction do
          unsafe_call
        end
      end

      private

      def unsafe_call
        # to be soft deleted, a section must be a singleton AND declared as recoverable in the layout group
        if can_soft_delete?
          soft_delete_section!(store)
        else
          # we never delete site scoped sections:
          # A page might not need it anymore but others might still need it.
          delete_section!(store)
        end.tap { touch_page(store) }
      end

      def can_soft_delete?
        return false if layout_id.blank?
        theme.find_layout(layout_id).find_group(store.handle).recoverable?(section_definition)
      end

      def delete_section!(source)
        source.sections_translations_will_change!
        source.delete_section(section_id)
        source.save!
      end

      def soft_delete_section!(store)
        store.sections_translations_will_change!
        store.soft_delete_section(section_id)
        store.save!
      end
    end
  end
end
