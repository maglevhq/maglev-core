# frozen_string_literal: true

module Maglev
  module Editor
    module NewSectionConcern
      extend ActiveSupport::Concern

      included do
        helper_method :addable_section_categories
      end

      private

      def set_query_and_category_id
        # we can't filter by both query and category_id in the same time
        @query = params[:category_id].present? ? nil : params[:query]
        # if no category_id is provided AND we don't have a query, we take the first category
        # which has at least one section that can be added to the store
        @category_id = params[:category_id] || addable_section_categories.first&.id
        @category_id = nil if @query.present?
      end

      def addable_section_categories
        addable_category_ids = maglev_theme.sections.available_for(@sections_store_content).map(&:category).uniq
        maglev_theme.section_categories.select { |category| addable_category_ids.include?(category.id) }
      end
    end
  end
end
