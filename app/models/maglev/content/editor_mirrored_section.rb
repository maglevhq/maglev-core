# frozen_string_literal: true

module Maglev
  module Content
    class EditorMirroredSection
      include ActiveModel::Model
      include ActiveModel::Attributes

      ## validations ##
      validates :page_id, presence: true
      validates :section_id, presence: true

      ## attributes ##
      attribute :position, :integer
      attribute :page_id, :string
      attribute :section_id, :string # format: ":layout_store_id/:section_type/:section_id"

      ## methods ##

      def section_type
        section_id.split('/').second
      end

      def to_mirror_of
        {
          page_id: page_id,
          layout_store_id: section_id.split('/').first,
          section_id: section_id.split('/').last
        }
      end
    end
  end
end
