module Maglev
  class FetchPage
    include Injectable

    argument :params

    def call
      Maglev::Page.where(path: params[:path] || 'index').first
    end
  end
end
