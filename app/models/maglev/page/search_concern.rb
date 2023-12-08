# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
module Maglev::Page::SearchConcern
  extend ActiveSupport::Concern

  class_methods do
    def search(keyword, locale)
      return [] if keyword.blank?

      title = search_title_node(locale)
      query = all.select(Maglev::Page.arel_table[Arel.star], title).distinct.joins(:paths).order(title.asc)
      matching = "%#{keyword}%"

      query.where(
        search_title_clause(matching, locale).or(
          search_path_clause(matching, locale)
        )
      )
    end

    protected

    def search_title_clause(query, locale)
      search_title_node(locale).matches(query)
    end

    def search_path_clause(query, locale)
      path = Maglev::PagePath.arel_table[:value]
      path_locale = Maglev::PagePath.arel_table[:locale]
      path.matches(query).and(path_locale.eq(locale))
    end

    def search_title_node(locale)
      Arel::Nodes::InfixOperation.new('->>',
                                      arel_table[:title_translations],
                                      Arel::Nodes.build_quoted(locale))
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
