# frozen_string_literal: true

module Maglev
  class FetchPage
    include Injectable

    argument :params

    def call
      Maglev::Page.by_path(params[:path] || 'index').first
    end
  end
end
