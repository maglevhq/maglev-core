# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::PagePreviewController', type: :request do
  let(:theme) { build(:theme, :predefined_pages) }
  let!(:site) do
    Maglev::GenerateSite.call(theme: theme)
  end

  describe 'rendering sections outside the theme layout' do
    let(:product) { create(:product, name: 'My awesome product') }
    it 'renders a page of the main app' do      
      get "/products/#{product.id}"
      puts pretty_html(response.body)
      expect(pretty_html(response.body))
        .to eq(<<-HTML.strip
<html>
  <head>
    <title>
      My awesome product
    </title>
  </head>
  <body>
    <h1>My awesome product</h1>
    <p>Price: $42.00</p>
  </body>
</html>
        HTML
      )
    end
  end
end