# frozen_string_literal: true

require 'rails_helper'

describe 'Maglev::Editor::Links', type: :request do
  let!(:site) { create(:site) }

  describe 'GET /maglev/editor/link/edit' do
    it 'returns a success response' do
      get '/maglev/editor/link/edit',
          params: { link: { href: '/contact_us', link_type: 'url' }, input_name: 'link' },
          headers: { "Turbo-Frame": 'modal' }
      expect(response).to be_successful
    end
  end

  describe 'PUT /maglev/editor/link' do
    it 'returns a success response' do
      put '/maglev/editor/link',
          as: :turbo_stream,
          params: { link: { href: '/contact_us', link_type: 'url' }, input_name: 'link' },
          headers: { "Turbo-Frame": 'modal' }
      expect(response).to be_successful
    end
  end
end
