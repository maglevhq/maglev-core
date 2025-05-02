# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::Admin::Sections::PreviewsController', type: :request do
  let!(:site) do
    Maglev::GenerateSite.call(theme: build(:theme, :predefined_pages))
  end

  context 'previewing a section' do
    it 'renders the iframe which will display the section' do
      get '/maglev/admin/sections/jumbotron/preview'
      expect(response.body).to include('src="/maglev/admin/sections/jumbotron/preview_in_frame"')
    end

    it 'renders the HTML of a section within the theme layout' do
      get '/maglev/admin/sections/jumbotron/preview_in_frame'
      expect(response.body).to match(%r{<h1 data-maglev-id="[0-9a-zA-Z\-_.]+\.title" class="display-3">Title</h1>})
      expect(response.body).to match(%r{<div data-maglev-id="[0-9a-zA-Z\-_.]+\.body">Body</div>})
    end
  end
end
