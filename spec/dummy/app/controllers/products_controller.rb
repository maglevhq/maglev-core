class ProductsController < ApplicationController

  include Maglev::ServicesConcern
  include Maglev::FetchersConcern

  helper Maglev::PagePreviewHelper

  def show
    fetch_site_scoped_sections
    @product = Product.find(params[:id])
  end

end