# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::Sections::PreviewsController', type: :request do
  let!(:site) do
    Maglev::GenerateSite.new(
      fetch_theme: double('FetchTheme', call: build(:theme, :predefined_pages)),
      setup_pages: Maglev::SetupPages.new
    ).call
  end

  context 'previewing a section' do
    it 'renders the iframe which will display the section' do
      get '/maglev/sections/preview/jumbotron'
      expect(response.body).to include('src="/maglev/sections/preview_in_frame?id=jumbotron"')
    end
    it 'renders the HTML of a section within the theme layout' do
      get '/maglev/sections/preview_in_frame?id=jumbotron'
      expect(response.body).to match(%r{<h1 data-maglev-id="[0-9a-zA-Z\-_]+\.title" class="display-3">Title</h1>})
      expect(response.body).to match(%r{<div data-maglev-id="[0-9a-zA-Z\-_]+\.body">Body</div>})
    end
  end
end
