# frozen_string_literal: true

module Maglev
  module RenderingConcern
    extend ActiveSupport::Concern

    included do
      include Maglev::FetchersConcern
    end

    private

    def render_maglev_page
      fetch_maglev_page_content

      verify_canonical_path and return

      render template: fetch_maglev_theme_layout, layout: false
    end

    def verify_canonical_path
      # the section mode is only used to display the content of a single section
      # in the admin UI.
      return if maglev_rendering_mode == :section

      # check if we're processing the right version (canonical) of the page
      # if not, follow the proper SEO rule by redirecting the user with a 301
      canonical_path = maglev_page.path

      return false if !canonical_path || params[:path] == canonical_path

      next_path = maglev_rendering_mode == :editor ? site_preview_path(path: canonical_path) : "/#{canonical_path}"
      redirect_to next_path, status: :moved_permanently

      true
    end
  end
end
