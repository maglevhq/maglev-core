# frozen_string_literal: true

module Maglev
  module Content
    class DeleteSectionService
      include Injectable
      include Maglev::Content::HelpersConcern

      dependency :fetch_theme
      dependency :fetch_site

      argument :page
      argument :section_id

      def call
        raise Maglev::Errors::UnknownSection unless section_definition

        ActiveRecord::Base.transaction do
          delete_section!(site) if site_scoped?
          delete_section!(page)
        end
      end

      private

      def delete_section!(source)
        source.sections_translations_will_change!
        source.delete_section(section_id)
        source.save!
      end
    end
  end
end
