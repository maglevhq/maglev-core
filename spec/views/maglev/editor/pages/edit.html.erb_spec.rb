require "rails_helper"

RSpec.describe "maglev/editor/pages/edit" do
  let(:page) { build(:page) }

  around(:example) do |example|
    without_partial_double_verification do
      example.call
    end
  end

  before do
    allow(view).to receive(:current_maglev_page).and_return(page)
    allow(view).to receive(:editor_real_root_path).and_return('#')
    allow(view).to receive(:editor_page_path).and_return('#')
    allow(view).to receive(:maglev_button_classes).and_return('')
    # allow(controller).to receive(:current_maglev_page).and_return(page)
    # allow_any_instance_of(ApplicationController).to receive(:current_maglev_page).and_return(page)
  end

  it "displays the form" do
    assign(:page, page)

    render

    pp rendered

    expect(rendered).to match /<label/
  end
end