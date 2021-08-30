# frozen_string_literal: true

module Maglev
  module StandaloneSectionsConcern
    extend ActiveSupport::Concern

    included do
      include Maglev::ServicesConcern
      include Maglev::FetchersConcern

      helper Maglev::PagePreviewHelper
    end

    private

    def fetch_maglev_site_scoped_sections
      fetch_maglev_site
      fetch_maglev_theme
      fetch_maglev_dummy_page
      fetch_maglev_page_sections
    end

    def fetch_maglev_dummy_page
      @fetch_maglev_page = ::Maglev::Page.new(title: 'DummyPage', sections: fetch_maglev_site.sections)
    end
  end
end
