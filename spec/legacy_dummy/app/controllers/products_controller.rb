# frozen_string_literal: true

class ProductsController < ApplicationController
  include Maglev::StandaloneSectionsConcern

  def show
    fetch_maglev_site_scoped_sections
    @product = Product.find(params[:id])
  end
end
