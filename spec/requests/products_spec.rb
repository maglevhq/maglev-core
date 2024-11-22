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
      expect(response.body).to include('<title>My awesome product</title>')
      expect(response.body).to include('<div class="navbar" id="section-yyy" data-maglev-section-id="yyy" data-maglev-section-type="navbar">')
      expect(response.body).to include('<h1>My awesome product</h1>')
      expect(response.body).to include('<p>Price: $42.00</p>')
    end
  end
end
