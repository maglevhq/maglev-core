# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::PagePreviewController', type: :request do
  let(:theme) { build(:theme, :predefined_pages) }
  let!(:site) do
    Maglev::GenerateSite.call(theme: theme)
  end

  describe 'rendering sections outside the theme layout' do
    before do
      site.update!(
        sections: attributes_for(:site, :with_navbar)[:sections]
      )
    end

    let(:product) { create(:product, name: 'My awesome product') }

    it 'renders a page of the main app' do
      get "/products/#{product.id}"

      doc = parse_html(response.body)

      # Check the page title
      title_element = expect_element_present(doc, 'title')
      expect_element_text(title_element, 'My awesome product')

      # Check the navbar section
      navbar_div = expect_element_present(doc, 'div[data-maglev-section-id="yyy"]')
      expect_element_attributes(navbar_div, {
                                  id: 'section-yyy',
                                  "data-maglev-section-type": 'navbar'
                                })

      # Check the main heading
      h1_element = expect_element_present(doc, 'h1')
      expect_element_text(h1_element, 'My awesome product')

      # Check the price paragraph
      price_paragraph = expect_element_present(doc, 'p')
      expect_element_text(price_paragraph, 'Price: $42.00')
    end
  end
end
