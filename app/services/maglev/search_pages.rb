# frozen_string_literal: true

module Maglev
  # Search for a single page if the id param is passed to the call function
  # or search for all the pages matching or not the q criteria (based on its presence).
  # It also searches among the static pages
  class SearchPages
    include Injectable

    dependency :fetch_site
    dependency :fetch_static_pages

    argument :id, default: nil
    argument :q, default: nil
    argument :content_locale

    def call
      id.nil? ? all_pages : single_page
    end

    protected

    def single_page
      resources.by_id_or_path(id).first ||
      resources.by_id_or_path(id, content_locale).first ||
      find_static_pages.find { |page| page.id === id }
    end

    def all_pages
      find_persisted_pages + find_static_pages
    end

    def find_persisted_pages
      q ? resources.search(q, content_locale) : resources.all
    end

    def find_static_pages
      Maglev::I18n.with_locale(content_locale) do 
        fetch_static_pages.call.find_all do |page|
          q.nil? || (
            q.present? && 
            (
              page.title.downcase.include?(q.downcase) || 
              page.path.include?(q.downcase)
            )
          )
        end
      end
    end

    def resources
      ::Maglev::Page
    end
  end
end
