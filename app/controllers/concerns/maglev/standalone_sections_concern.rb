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
      @site = fetch_site
      @theme = fetch_theme
      @page = @fetch_page = Maglev::Page.new(title: 'DummyPage', sections: @site.sections)
      @page_sections = fetch_page_sections
    end
  end
end
