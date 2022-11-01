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
      expect(pretty_html(response.body))
        .to eq(<<~HTML.strip
          <html>
            <head>
              <title>
                My awesome product
              </title>
            </head>
            <body>
              <div class="navbar" id="section-yyy" data-maglev-section-id="yyy">
                <a href="/">
                  <img src="mynewlogo.png" data-maglev-id="yyy.logo" class="brand-logo"/>
                </a>
                <nav>
                  <ul>
                    <li class="navbar-item" id="block-zzz" data-maglev-block-id="zzz">
                      <a data-maglev-id="zzz.link" target="_blank" href="https://www.nocoffee.fr">
                        <em>
                          <span data-maglev-id="zzz.label">Home</span>
                        </em>
                      </a>
                    </li>
                  </ul>
                </nav>
              </div>
              <h1>My awesome product</h1>
              <p>Price: $42.00</p>
            </body>
          </html>
        HTML
              )
    end
  end
end
