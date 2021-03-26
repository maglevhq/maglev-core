# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::Sections::Previews', type: :request do
  context 'previewing a section' do
    let!(:site) { Maglev::Site.generate!(name: 'My site') }

    it 'renders the HTML of a section within the theme layout' do
      get '/maglev/sections/preview/jumbotron'
      expect(response.body).to match(%r{<h1 data-maglev-id="\w+\.title" class="display-3">Title</h1>})
      expect(response.body).to match(%r{<div data-maglev-id="\w+\.body">Body</div>})
    end
  end
end
