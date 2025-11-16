# frozen_string_literal: true

require 'rails_helper'

describe 'Maglev::SiteController' do
  describe 'POST #create' do
    it 'creates a new site' do
      expect do
        post '/maglev/site'
      end.to change(Maglev::Site, :count).by(1)
      expect(response).to have_http_status(:redirect)
    end

    context 'when the site already exists' do
      before { create(:site) }
      it 'does not create a new site' do
        expect do
          post '/maglev/site'
        end.not_to change(Maglev::Site, :count)
      end
    end
  end
end
