# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::Sections::ScreenshotsController', type: :request do
  context 'creating a screenshot of a section' do
    it 'calls the take_section_screenshot service' do
      post
    end
  end

  context 'previewing a section' do
    it 'renders the iframe which will display the section' do
      get '/maglev/themes/simple/sections/preview/jumbotron'
      expect(response.body).to include('src="/maglev/themes/simple/sections/preview_in_frame?id=jumbotron"')
    end
    it 'renders the HTML of a section within the theme layout' do
      get '/maglev/sections/preview_in_frame?id=jumbotron'
      expect(response.body).to match(%r{<h1 data-maglev-id="[0-9a-zA-Z\-_]+\.title" class="display-3">Title</h1>})
      expect(response.body).to match(%r{<div data-maglev-id="[0-9a-zA-Z\-_]+\.body">Body</div>})
    end
  end
end
