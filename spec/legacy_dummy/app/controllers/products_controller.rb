# frozen_string_literal: true

class ProductsController < ApplicationController
  include Maglev::StandaloneSectionsConcern

  before_action { fetch_maglev_sections_content(layout_id: 'default') }

  def show
    @product = Product.find(params[:id])
  end
end
