# frozen_string_literal: true

module Maglev
  class EditorController < ApplicationController
    include Maglev::FetchersConcern

    def show
      fetch_page_content
      @home_page_id = ::Maglev::Page.home.pick(:id)
      render layout: nil
    end
  end
end
